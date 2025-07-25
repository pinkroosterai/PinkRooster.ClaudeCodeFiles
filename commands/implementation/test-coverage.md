---
name: test-coverage
description: Review existing tests and implement missing tests with configurable edge case coverage
tools: [Bash, Glob, Grep, Read, Write, Edit, MultiEdit, Task]
---

# Test Coverage Analysis and Implementation

Analyze the current test suite, identify gaps, and generate comprehensive tests with configurable edge case coverage.

## Arguments
- `$1` (optional): Target service/class name to focus on (e.g., "SignatureParser", "EntityFinder")
- `$2` (optional): Edge case coverage level (1-5, default: 3)
  - 1: Basic happy path tests only
  - 2: Basic + null/empty input validation
  - 3: Standard edge cases + boundary values
  - 4: Comprehensive edge cases + error conditions
  - 5: Exhaustive edge cases + performance scenarios

## Context Gathering

!get-context build
!get-context csharp
!find . -name "*Tests.cs" -type f | head -10

## Phase 1: Test Coverage Analysis

### Discover Existing Test Structure
```bash
# Map existing test files to source files
find . -name "*.cs" -path "*/Services/*" ! -path "*/Tests/*" | sort > /tmp/services.txt
find . -name "*Tests.cs" | sort > /tmp/tests.txt

echo "=== Service Files Without Tests ==="
while read -r service; do
    basename_service=$(basename "$service" .cs)
    if ! grep -q "${basename_service}Tests.cs" /tmp/tests.txt; then
        echo "❌ Missing tests for: $service"
    fi
done < /tmp/services.txt

echo "=== Existing Test Coverage ==="
while read -r test; do
    basename_test=$(basename "$test" Tests.cs)
    if grep -q "${basename_test}.cs" /tmp/services.txt; then
        echo "✅ Has tests: $basename_test"
    fi
done < /tmp/tests.txt
```

### Analyze Test Quality and Completeness
```bash
echo "=== Test Method Analysis ==="
for test_file in $(find . -name "*Tests.cs"); do
    echo "📄 $test_file:"
    grep -n "\[Fact\]\|\[Theory\]" "$test_file" | wc -l | xargs echo "  Test methods:"
    grep -n "public.*Test\|public.*Should" "$test_file" | head -5
    echo
done
```

## Phase 2: Gap Identification

Use Task tool to analyze test gaps:
```markdown
Task(description="Analyze test coverage gaps", subagent_type="dotnet-reviewer", prompt="
Review the current test suite structure and identify:
1. Services/classes without any test coverage
2. Public methods in tested classes that lack test coverage
3. Edge cases and error conditions that aren't tested
4. Missing integration tests for complex workflows

Focus on: ${1:-all services}
Edge case level: ${2:-3}

Provide a structured report with prioritized recommendations.
")
```

## Phase 3: Test Implementation Strategy

### Determine Test Framework Patterns
```bash
# Analyze existing test patterns
echo "=== Test Framework Analysis ==="
head -20 $(find . -name "*Tests.cs" | head -1) | grep -E "using|namespace|class"

echo "=== Common Test Patterns ==="
grep -h "public.*Test\|Should_.*When\|Given.*When.*Then" $(find . -name "*Tests.cs") | head -10
```

### Generate Missing Tests

Use specialized agents for test implementation:

```markdown
# For C# service tests
Task(description="Generate comprehensive unit tests", subagent_type="dotnet-developer", prompt="
Generate complete unit test suite for ${1:-identified services} with edge case coverage level ${2:-3}.

Requirements:
- Follow existing xUnit + FluentAssertions + Moq patterns
- Include test categories: Happy path, Edge cases, Error conditions, Boundary values
- Generate parameterized tests using [Theory] where appropriate
- Mock dependencies using Moq
- Use FluentAssertions for readable assertions
- Follow AAA (Arrange-Act-Assert) pattern
- Include XML documentation for complex test scenarios

Edge case coverage level ${2:-3} should include:
Level 1: Basic functionality tests
Level 2: + Null/empty validation
Level 3: + Boundary values, invalid inputs
Level 4: + Exception scenarios, concurrent access
Level 5: + Performance edge cases, memory constraints
")
```

## Phase 4: Test File Generation

### Create Test Files for Uncovered Services
```bash
# Generate test file structure for missing tests
for service_file in $(cat /tmp/services.txt); do
    service_name=$(basename "$service_file" .cs)
    test_file="./NajsCoder.McpServer.Tests/Services/${service_name}Tests.cs"
    
    if [ ! -f "$test_file" ]; then
        echo "Creating test file: $test_file"
        # Template will be filled by the agent
    fi
done
```

### Implement Test Templates

Use Task tool for actual test code generation:
```markdown
Task(description="Implement test file templates", subagent_type="dotnet-developer", prompt="
Create test files for services without coverage using this template structure:

```csharp
using FluentAssertions;
using Moq;
using Xunit;
using NajsCoder.McpServer.Services;

namespace NajsCoder.McpServer.Tests.Services;

/// <summary>
/// Unit tests for [ServiceName] with edge case coverage level ${2:-3}
/// </summary>
public class [ServiceName]Tests
{
    private readonly Mock<IDependency> _mockDependency;
    private readonly [ServiceName] _sut;

    public [ServiceName]Tests()
    {
        _mockDependency = new Mock<IDependency>();
        _sut = new [ServiceName](_mockDependency.Object);
    }

    [Fact]
    public void Method_Should_ReturnExpectedResult_When_ValidInput()
    {
        // Arrange
        
        // Act
        
        // Assert
    }

    // Additional test methods based on edge case level
}
```

Generate complete test implementations for each identified service.
")
```

## Phase 5: Test Validation and Execution

### Run Generated Tests
```bash
echo "=== Running Test Suite ==="
dotnet test --no-build --verbosity normal

echo "=== Test Coverage Report ==="
dotnet test --collect:"XPlat Code Coverage" --results-directory ./TestResults

if command -v reportgenerator &> /dev/null; then
    reportgenerator -reports:"./TestResults/*/coverage.cobertura.xml" -targetdir:"./CoverageReport" -reporttypes:Html
    echo "Coverage report generated in ./CoverageReport"
fi
```

### Validate Test Quality
```bash
echo "=== Test Quality Metrics ==="
total_tests=$(find . -name "*Tests.cs" -exec grep -l "\[Fact\]\|\[Theory\]" {} \; | wc -l)
test_methods=$(find . -name "*Tests.cs" -exec grep -h "\[Fact\]\|\[Theory\]" {} \; | wc -l)
echo "Test files: $total_tests"
echo "Test methods: $test_methods"

echo "=== Edge Case Coverage Verification ==="
case "${2:-3}" in
    1) echo "Verifying basic functionality tests...";;
    2) echo "Verifying null/empty input validation...";;
    3) echo "Verifying boundary values and edge cases...";;
    4) echo "Verifying exception scenarios...";;
    5) echo "Verifying performance edge cases...";;
esac
```

## Phase 6: Integration and Refinement

### Code Review Generated Tests
Use Task tool for quality review:
```markdown
Task(description="Review generated test quality", subagent_type="dotnet-reviewer", prompt="
Review the generated test files for:
1. Adherence to existing code conventions
2. Proper use of test frameworks (xUnit, FluentAssertions, Moq)
3. Comprehensive coverage of edge cases for level ${2:-3}
4. Clear test naming and documentation
5. Proper AAA pattern implementation
6. Appropriate use of parameterized tests

Provide specific feedback and improvement suggestions.
")
```

### Update Project Files
```bash
echo "=== Updating Test Project References ==="
# Ensure all new test files are included in the project
dotnet build ./NajsCoder.McpServer.Tests/NajsCoder.McpServer.Tests.csproj
```

## Usage Examples

```bash
# Analyze all services with standard edge case coverage
/test-coverage

# Focus on specific service with basic coverage
/test-coverage SignatureParser 1

# Comprehensive analysis with maximum edge case coverage
/test-coverage EntityFinder 5

# Generate tests for all uncovered services with high edge case coverage
/test-coverage "" 4
```

## Success Criteria

- ✅ All services have corresponding test files
- ✅ Edge case coverage matches specified level (1-5)
- ✅ Generated tests follow project conventions
- ✅ All tests pass and integrate with existing suite
- ✅ Test coverage metrics show improvement
- ✅ Code review validates test quality

## Integration Notes

This command leverages multiple specialized agents:
- **dotnet-reviewer**: For analyzing existing code and test patterns
- **dotnet-developer**: For generating comprehensive test implementations
- **code-optimizer**: For performance-related edge case testing (level 5)

The command automatically adapts to the existing codebase structure and follows established patterns for maximum integration success.