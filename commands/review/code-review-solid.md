# Code Review: SOLID & KISS Principles

Review codebase for SOLID principle violations, KISS violations, and opportunities to apply YAGNI and avoid Not-Invented-Here syndrome.

## Usage
```bash
/code-review-solid [target-path] [--severity=all|high|critical] [--principles=solid,kiss,yagni,nih] [--fix]
```

## Arguments
- `target-path` (optional): Specific file or directory to review. Defaults to current directory
- `--severity`: Filter by violation severity (all, high, critical). Default: all
- `--principles`: Comma-separated list of principles to check (solid, kiss, yagni, nih). Default: all
- `--fix`: Automatically apply fixes where safe to do so

## Examples
```bash
/code-review-solid                           # Review entire codebase
/code-review-solid src/Services              # Review specific directory
/code-review-solid --severity=critical       # Only critical violations
/code-review-solid --principles=solid,kiss   # Only SOLID and KISS violations
/code-review-solid UserService.cs --fix     # Review and fix specific file
```

---

## Context Gathering

Collect comprehensive information about the codebase structure and current state:

```bash
!get-context full
```

## Analysis Phase

### 1. SOLID Principles Violation Detection

**Single Responsibility Principle (SRP)**
- Look for classes/methods doing multiple unrelated things
- Identify mixed concerns (UI logic in business classes, data access in controllers)
- Find classes with multiple reasons to change

**Open/Closed Principle (OCP)**
- Identify switch/case statements that violate extensibility
- Look for modification requirements instead of extension opportunities
- Find hard-coded dependencies that prevent extension

**Liskov Substitution Principle (LSP)**
- Check inheritance hierarchies for behavioral contract violations
- Identify derived classes that change expected behavior
- Look for type checking in polymorphic code

**Interface Segregation Principle (ISP)**
- Find fat interfaces with unrelated methods
- Identify clients forced to depend on unused interface methods
- Look for interface pollution

**Dependency Inversion Principle (DIP)**
- Check for high-level modules depending on low-level modules
- Identify concrete dependencies instead of abstractions
- Look for new keyword usage in business logic

### 2. KISS (Keep It Simple, Stupid) Violations

- Over-engineered solutions for simple problems
- Unnecessary abstraction layers
- Complex inheritance hierarchies where composition would suffice
- Overly clever code that sacrifices readability
- Premature optimization without performance requirements

### 3. YAGNI (You Aren't Gonna Need It) Violations  

- Unused classes, methods, or properties
- Generic solutions for specific problems
- Infrastructure built for future requirements
- Complex configuration systems for simple scenarios
- Flexible architectures without demonstrated need

### 4. Not-Invented-Here (NIH) Syndrome

- Custom implementations of existing library functionality
- Reinventing standard patterns poorly
- Avoiding mature third-party solutions without justification
- Building complex utilities when simple alternatives exist

## Severity Classification

**Critical**: Major architectural violations that impact maintainability
**High**: Clear principle violations with moderate impact
**Medium**: Minor violations or potential improvements
**Low**: Style/preference issues with minimal impact

## Fix Recommendations

For each violation found, provide:

1. **Problem Description**: Clear explanation of the violation
2. **Impact Assessment**: Why this matters for code quality
3. **Refactoring Steps**: Specific steps to fix the issue
4. **Code Examples**: Before/after code samples where helpful
5. **Testing Considerations**: How to verify the fix doesn't break functionality

## Implementation Recommendations

When `--fix` flag is used, apply safe automated fixes:

- Extract methods to reduce SRP violations
- Replace switch statements with polymorphism
- Introduce interfaces to improve DIP compliance
- Remove unused code (YAGNI violations)
- Suggest library replacements for NIH violations

## Agent Integration

For complex refactoring tasks, engage specialized agents:

```markdown
Use the Task tool for major refactoring:
- For C# architectural changes: `Task(description="Refactor architecture", subagent_type="solution-architect")`
- For code optimization: `Task(description="Optimize code", subagent_type="code-optimizer")`  
- For documentation updates: `Task(description="Update docs", subagent_type="documentation-writer")`
```

## Output Format

```markdown
# Code Review Results: SOLID & KISS Principles

## Summary
- **Files Analyzed**: X files
- **Violations Found**: X total (Y critical, Z high)
- **Principles Checked**: SOLID, KISS, YAGNI, NIH

## Critical Violations
### [File:Line] - Principle Violation
**Issue**: Description of the problem
**Impact**: Why this matters
**Fix**: Specific refactoring steps
**Example**: Code snippet if helpful

## High Priority Violations
[Same format as critical]

## Recommendations
- Priority fixes in order of importance
- Architectural improvements
- Library/framework suggestions for NIH violations
- YAGNI cleanup opportunities

## Automated Fixes Applied
[If --fix flag used]
- List of safe fixes that were automatically applied
- Files modified
- Testing recommendations
```

## Safety Considerations

- Never modify code without explicit `--fix` flag
- Only apply safe, reversible fixes automatically  
- Always recommend manual testing after fixes
- Preserve existing behavior unless explicitly changing it
- Create backups before major refactoring suggestions

## Integration with Existing Workflow

- Works with existing C# project structure
- Respects .gitignore patterns
- Integrates with build/test processes
- Compatible with existing linting tools
- Provides actionable, prioritized recommendations