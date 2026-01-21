# Go Programming Preferences

These instructions apply when working with Go code.

## Generated Files

**NEVER manually modify generated files.** Generated files are managed by code
generation tools and any manual changes will be overwritten.

**Common generated files include:**
- Mock implementations (e.g., `mock_*.go`, `*_mock.go`, files in `mocks/` directories)
- Protocol buffer generated code (`*.pb.go`)
- gowrap generated wrappers
- Any file with a `// Code generated ... DO NOT EDIT.` header comment

**Rules:**
- If a generated file needs changes, modify the source (interface, proto file, template) and regenerate
- Run `make mocks` after interface changes to regenerate mock files
- Run `make generate` to regenerate protobuf wrappers
- If you see incorrect behavior in generated code, investigate the generator configuration or template

## Testing

### Test Package Naming

- **NEVER use the `_test` package suffix for unit tests**
- Unit tests MUST use the same package name as the code being tested
- Example: If testing `package foo`, the test file must use `package foo`, NOT `package foo_test`
- This allows testing of unexported functions and internal implementation details
- If you encounter import cycles with mockery-generated mocks, use `export_test.go` pattern to expose unexported functions

**Example:**
```go
// foo.go
package foo

func DoSomething() {}
func helper() {}  // unexported

// foo_test.go
package foo  // ✅ Correct - same package

import "testing"

func TestHelper(t *testing.T) {
    helper()  // Can test unexported functions
}
```

### Test Execution Rules

- **Integration tests**: MUST be run with `-tags=integration` build flag
  - Example: `go test -tags=integration ./path/to/package`
- **Unit tests**: Run by default with no build flags needed
  - Example: `go test ./path/to/package`
- **Note**: When running integration tests, unit tests will also execute alongside them

### When the user requests:
- "run integration tests" → Use `-tags=integration`
- "run unit tests" → No build flags needed
- "run tests" (ambiguous) → Clarify with user which type they want

### Test Concurrency Requirements

**ALL tests MUST be written to be safely runnable in parallel** with other
tests. This enables faster test execution and helps discover bugs related
to shared state.

**Rules for parallel-safe tests:**
- Avoid shared global state between tests
- Use unique identifiers (UUIDs, random strings) instead of hardcoded IDs
- Each test must be fully independent and not rely on execution order
- Never assume a specific test execution sequence
- Tests should work correctly whether run sequentially or concurrently

**Generating unique test data:**
```go
// ✅ Correct - Unique IDs prevent conflicts between parallel tests
func TestCreateUser(t *testing.T) {
    userID := uuid.New().String()
    email := fmt.Sprintf("test-%s@example.com", userID)

    user := CreateUser(userID, email)
    // Test code
}

// ❌ Incorrect - Hardcoded IDs cause conflicts in parallel execution
func TestCreateUser(t *testing.T) {
    // Multiple tests running concurrently will conflict on ID "123"
    user := CreateUser("123", "test@example.com")
}

// ✅ Correct - Unique table names for database tests
func TestDatabaseOperations(t *testing.T) {
    tableName := fmt.Sprintf("test_table_%s", uuid.New().String())
    db.CreateTable(tableName)
    // Test code
}
```

### Test Cleanup

**ALL tests MUST clean up after themselves**, leaving the system in the
state it was found. Cleanup MUST occur whether the test passes or fails.
**Cleanup operations MUST be asserted** to catch silent failures.

```go
// ✅ Correct - Assert cleanup operations with require
func TestCreateUser(t *testing.T) {
    userID := uuid.New().String()
    user, err := CreateUser(userID, "test@example.com")
    require.NoError(t, err)

    t.Cleanup(func() {
        err := DeleteUser(userID)
        require.NoError(t, err, "cleanup: failed to delete user")
    })

    // Test assertions
    assert.NotNil(t, user)
}

// ✅ Correct - Multiple cleanups with assertions (run in reverse order)
func TestDatabaseOperations(t *testing.T) {
    // Create table
    tableName := fmt.Sprintf("test_table_%s", uuid.New().String())
    err := db.CreateTable(tableName)
    require.NoError(t, err)

    t.Cleanup(func() {
        err := db.DropTable(tableName)
        require.NoError(t, err, "cleanup: failed to drop table")
    })

    // Insert row
    rowID := uuid.New().String()
    err = db.Insert(tableName, rowID, data)
    require.NoError(t, err)

    t.Cleanup(func() {
        err := db.Delete(tableName, rowID)
        require.NoError(t, err, "cleanup: failed to delete row")
    })

    // Test code - both cleanups run in reverse order
}

// ✅ Correct - defer with assertion for simple cleanup
func TestFileOperations(t *testing.T) {
    tmpFile, err := createTempFile()
    require.NoError(t, err)

    defer func() {
        err := os.Remove(tmpFile)
        require.NoError(t, err, "cleanup: failed to remove temp file")
    }()

    // Test code
}

// ❌ Incorrect - Cleanup without assertions (silent failures)
func TestCreateUser(t *testing.T) {
    userID := uuid.New().String()
    user := CreateUser(userID, "test@example.com")

    t.Cleanup(func() {
        DeleteUser(userID) // Error ignored - cleanup may fail silently!
    })

    assert.NotNil(t, user)
}

// ❌ Incorrect - No cleanup at all
func TestCreateUser(t *testing.T) {
    user := CreateUser("123", "test@example.com")
    assert.NotNil(t, user)
    // User left in database!
}
```

**Rules for cleanup:**
- Use `t.Cleanup()` for cleanup that must run after all test code
- **ALWAYS assert cleanup operations** using `require.NoError(t, err)`
- Include descriptive messages in cleanup assertions (e.g., "cleanup: failed to...")
- Cleanup functions run in reverse order (LIFO) - last registered, first executed
- `t.Cleanup()` runs even if test fails or panics
- Use `defer` with assertions for simpler cleanup within the same scope
- Clean up ALL resources: database rows, tables, files, connections, goroutines
- Integration tests with databases MUST clean up all created data
- Silent cleanup failures can cause subsequent tests to fail - always assert

## Code Formatting

### Line Length Rules

- **Preferred line length**: 80 characters maximum
- **Absolute hard limit**: 120 characters (NEVER exceed this)
- Apply to all Go code: variable declarations, function calls, conditionals, comments, etc.
- **Comments**: MUST also follow line length limits - break long comments into multiple lines

### Function Signature Formatting

When function signatures would exceed line length limits, use this pattern:

```go
func longFunctionNameWithManyArgs(
    argOne TypeOne,
    argTwo TypeTwo,
    argThree TypeThree,
) (ReturnType1, ReturnType2) {
    // function body
}
```

**Rules for function signatures:**
- Each parameter on its own line with proper indentation
- Opening parenthesis on same line as function name
- Closing parenthesis and return types on their own line
- One tab indent for parameters

## Error Handling

### Return Values with Errors

When a function returns both a slice and an error, return `nil` for the slice when returning an error:

```go
// ✅ Correct - return nil slice with error
func getItems() ([]Item, error) {
    if err := validate(); err != nil {
        return nil, err
    }
    return items, nil
}

// ❌ Incorrect - don't return empty slice with error
func getItems() ([]Item, error) {
    if err := validate(); err != nil {
        return []Item{}, err  // wasteful allocation
    }
    return items, nil
}
```

**Rules:**
- Return `nil` for slice types when returning an error
- Return `nil` for map types when returning an error
- Return `nil` for pointer types when returning an error
- This avoids unnecessary allocations and follows Go conventions

### Error Assertions in Tests

**NEVER assert on error messages in tests.** Error messages are implementation details that may change.

```go
// ❌ FORBIDDEN - Do not assert on error messages
assert.EqualError(t, err, "failed to connect to database")
assert.Contains(t, err.Error(), "connection refused")

// ✅ Correct - Assert that an error occurred
assert.Error(t, err)

// ✅ Correct - Assert no error occurred
assert.NoError(t, err)

// ✅ Correct - Use ErrorIs for sentinel errors
assert.ErrorIs(t, err, ErrNotFound)
require.ErrorIs(t, err, ErrNotFound)

// ✅ Correct - Use ErrorAs for error type checking
var myErr *MyCustomError
assert.ErrorAs(t, err, &myErr)
require.ErrorAs(t, err, &myErr)
```

**Rules:**
- Use `assert.Error(t, err)` to verify an error occurred
- Use `assert.NoError(t, err)` to verify no error occurred
- Use `assert.ErrorIs(t, err, sentinel)` to check for specific sentinel errors
- Use `assert.ErrorAs(t, err, &target)` to check for specific error types
- NEVER use `assert.EqualError()` or check `err.Error()` contents

### Struct Comparisons in Tests

**Prefer using `github.com/google/go-cmp/cmp` for struct comparisons** instead of asserting each field individually.

```go
import "github.com/google/go-cmp/cmp"
import "github.com/google/go-cmp/cmp/cmpopts"

// ✅ Correct - Use cmp.Equal for struct comparison
func TestGetUser(t *testing.T) {
    got := GetUser(userID)
    want := User{
        ID:   userID,
        Name: "John Doe",
        Age:  30,
    }

    if !cmp.Equal(got, want) {
        t.Errorf("GetUser() mismatch (-want +got):\n%s", cmp.Diff(want, got))
    }
}

// ✅ Correct - Use cmpopts.IgnoreFields for non-deterministic fields
func TestCreateUser(t *testing.T) {
    got := CreateUser("John Doe")
    want := User{
        Name:      "John Doe",
        Age:       0,
        // ID and CreatedAt are generated, so we ignore them
    }

    opts := cmpopts.IgnoreFields(User{}, "ID", "CreatedAt")
    if !cmp.Equal(got, want, opts) {
        t.Errorf("CreateUser() mismatch (-want +got):\n%s",
            cmp.Diff(want, got, opts))
    }
}

// ❌ Avoid - Asserting each field individually
func TestGetUser(t *testing.T) {
    got := GetUser(userID)
    assert.Equal(t, userID, got.ID)
    assert.Equal(t, "John Doe", got.Name)
    assert.Equal(t, 30, got.Age)
}
```

**Rules:**
- Use `cmp.Equal(got, want)` for deep struct comparison
- Use `cmp.Diff(want, got)` in error messages to show differences
- `cmp` correctly handles `time.Time` using `.Equal()` internally
- Use `cmpopts.IgnoreFields()` to ignore non-deterministic fields:
  - Database-generated timestamps (`CreatedAt`, `UpdatedAt`)
  - Auto-generated UUIDs or IDs
  - Any other fields that vary between test runs
- In mock expectations with `mock.MatchedBy()`, use `cmp.Equal()` for struct comparison
- Benefits: cleaner code, better error messages, handles complex types correctly
