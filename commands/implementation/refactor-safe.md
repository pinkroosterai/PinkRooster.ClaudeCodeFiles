# Safe Code Refactoring

Safely refactor code based on code review findings with comprehensive backup, validation, and rollback capabilities.

## Usage
```bash
/refactor-safe [target-path] [--review-file=path] [--severity=all|high|critical] [--dry-run] [--backup-dir=path] [--validate-build] [--principles=solid,kiss,yagni,nih]
```

## Arguments
- `target-path` (optional): Specific file or directory to refactor. Defaults to current directory
- `--review-file`: Path to code review report file (markdown format). If not provided, runs review first
- `--severity`: Filter refactoring by violation severity (all, high, critical). Default: high,critical
- `--dry-run`: Preview changes without applying them
- `--backup-dir`: Custom backup directory. Default: .refactor-backup-{timestamp}
- `--validate-build`: Run build/tests after each refactoring step for validation
- `--principles`: Comma-separated principles to focus on (solid, kiss, yagni, nih). Default: solid

## Examples
```bash
/refactor-safe                                    # Refactor current directory after running review
/refactor-safe src/Services                       # Refactor specific directory
/refactor-safe --review-file=review-report.md     # Use existing review report
/refactor-safe --dry-run --severity=critical      # Preview critical fixes only
/refactor-safe --validate-build --backup-dir=./backup  # Custom backup with build validation
/refactor-safe UserService.cs --principles=solid       # Focus on SOLID principles for specific file
```

---

## Context Gathering

Collect comprehensive information about the current codebase state and any existing review findings:

```bash
!get-context review
```

## Safety Infrastructure Setup

Before any refactoring, establish comprehensive safety mechanisms:

### 1. Backup Creation

```bash
!git status --porcelain | wc -l
```

Create timestamped backup directory and preserve current state:
- Full codebase backup before any changes
- Git stash of uncommitted changes
- Build state snapshot for validation

### 2. Pre-Refactoring Validation

Establish baseline for comparison:
- Record current build status
- Capture test results if available
- Document current git state
- Verify no uncommitted critical changes

## Analysis Phase

### 1. Load or Generate Code Review

**If review file provided**: Load and parse existing review findings
**If no review file**: Generate comprehensive review using existing review command

```markdown
Use the Task tool to generate comprehensive review:
`Task(description="Generate SOLID code review", subagent_type="code-reviewer", prompt="/review:code-review-solid --severity=all")`
```

### 2. Prioritize Refactoring Tasks

Based on review findings, create prioritized refactoring plan:

**Critical Priority** (Apply immediately):
- SRP violations in large methods/classes
- Critical DIP violations preventing testability
- Dangerous static coupling

**High Priority** (Apply with validation):
- OCP violations limiting extensibility
- ISP violations creating fat interfaces
- Complex inheritance hierarchies

**Medium Priority** (Apply if safe):
- KISS violations and over-engineering
- Minor YAGNI cleanup
- Code organization improvements

## Safe Refactoring Implementation

### 1. Incremental Transformation Strategy

Apply refactoring in small, safe increments with validation at each step:

```markdown
For each refactoring task:
1. Create micro-backup of affected files
2. Apply minimal transformation
3. Validate compilation
4. Run tests if available
5. Commit intermediate state or rollback on failure
```

### 2. SOLID Principle Refactoring Agents

Use specialized agents for different refactoring types:

```markdown
**Single Responsibility Principle**:
`Task(description="Extract method responsibilities", subagent_type="dotnet-developer")`

**Dependency Inversion Principle**:
`Task(description="Create abstraction interfaces", subagent_type="solution-architect")`

**Open/Closed Principle**:
`Task(description="Implement extension patterns", subagent_type="dotnet-developer")`

**Interface Segregation**:
`Task(description="Split fat interfaces", subagent_type="api-designer")`

**Code Optimization**:
`Task(description="Optimize complex methods", subagent_type="code-optimizer")`
```

### 3. Refactoring Pattern Application

#### Extract Method Refactoring (SRP Violations)
- Identify method responsibility boundaries
- Extract pure functions first (lowest risk)
- Move to private methods, then consider service extraction
- Validate each extraction step

#### Dependency Injection Conversion (DIP Violations)
- Create interfaces for tightly coupled dependencies
- Implement dependency injection container
- Convert static methods to instance methods
- Add proper lifetime management

#### Static Class Elimination (OCP/Testing Issues)
- Convert static classes to concrete implementations
- Add interfaces for all public contracts
- Implement proper dependency injection
- Maintain backward compatibility during transition

#### Large Method Decomposition
- Extract validation logic to separate methods
- Separate data transformation from business logic
- Move file I/O operations to dedicated services
- Break complex conditionals into strategy patterns

## Validation and Safety Checks

### 1. Continuous Validation Strategy

After each refactoring step:

```bash
# Compilation validation
!dotnet build --no-restore --verbosity quiet

# Test validation (if tests exist)  
!dotnet test --no-build --verbosity quiet

# Static analysis validation
!dotnet analyze --verbosity quiet
```

### 2. Rollback Mechanisms

**Automatic Rollback Triggers**:
- Compilation failures
- Test failures (if --validate-build enabled)
- Critical static analysis violations
- File corruption or access errors

**Manual Rollback Commands**:
- Restore from backup directory
- Git reset to pre-refactoring state
- Selective file restoration

### 3. Progress Tracking

Maintain detailed log of all refactoring operations:
- Timestamp and operation type
- Files modified with line counts
- Success/failure status
- Rollback actions taken
- Validation results

## Risk Assessment Matrix

### Low Risk (Apply immediately)
- Extract pure functions
- Rename methods/variables for clarity
- Add documentation
- Minor code organization

### Medium Risk (Apply with validation)
- Convert static methods to instance methods
- Extract interfaces from concrete classes
- Restructure class hierarchies
- Move methods between classes

### High Risk (Apply with extensive validation)
- Change method signatures
- Modify inheritance relationships
- Large-scale namespace refactoring
- Breaking interface contracts

## Output Format

```markdown
# Safe Refactoring Results

## Summary
- **Files Analyzed**: X files
- **Refactoring Applied**: X operations
- **Safety Checks**: All passed
- **Backup Location**: .refactor-backup-timestamp
- **Build Status**: ✅ Success

## Critical Fixes Applied
### [File:Line] - Issue Type
**Refactoring**: Description of change made
**Risk Level**: Low/Medium/High
**Validation**: Compilation ✅ | Tests ✅ | Static Analysis ✅
**Rollback Point**: Available

## High Priority Fixes Applied
[Same format as critical]

## Validation Results
- **Compilation**: ✅ All projects build successfully
- **Tests**: ✅ All tests pass (X tests run)
- **Static Analysis**: ✅ No new warnings introduced
- **Build Performance**: ±X% change from baseline

## Safety Metrics
- **Backup Size**: X MB
- **Operations Applied**: X
- **Rollback Points Created**: X
- **Validation Failures**: X (auto-rolled back)

## Next Steps
- Commit refactored code with descriptive messages
- Run full integration test suite
- Update documentation if interfaces changed
- Consider additional refactoring for medium-priority items
- Archive backup after verification

## Rollback Instructions
If issues discovered after refactoring:
```bash
# Restore from backup
cp -r .refactor-backup-{timestamp}/* .

# Or use git reset
git reset --hard {commit-hash}
```
```

## Agent Integration Workflow

The command leverages multiple specialized agents for safe, efficient refactoring:

1. **code-reviewer**: Generate or enhance code review findings
2. **solution-architect**: Design interface abstractions and architecture improvements
3. **dotnet-developer**: Implement C# refactoring patterns safely
4. **code-optimizer**: Optimize complex algorithms and data structures
5. **api-designer**: Redesign interfaces following ISP principles
6. **bug-hunter**: Identify and fix issues introduced during refactoring

## Error Handling and Recovery

### Compilation Failures
- Immediate rollback to last working state
- Detailed error reporting with file/line information
- Suggestion for manual intervention if needed

### Test Failures  
- Rollback changed code
- Report which tests failed and likely causes
- Provide guidance for fixing test compatibility

### File System Errors
- Retry operations with exponential backoff
- Fallback to git-based rollback if file restore fails
- Preserve all intermediate states for recovery

### Dependency Conflicts
- Detect NuGet package issues after interface changes
- Suggest package updates or alternatives
- Rollback if dependencies cannot be resolved

## Safety Features

- **Atomic Operations**: Each refactoring step is atomic with rollback capability
- **State Preservation**: Multiple rollback points throughout the process
- **Validation Gates**: Compilation and test validation at each major step
- **Risk Assessment**: Automatic risk evaluation before applying changes
- **Progress Logging**: Detailed audit trail of all operations
- **Backup Verification**: Validate backup integrity before proceeding

This command prioritizes safety and reliability while systematically addressing code quality issues identified in reviews, making it ideal for production codebases where stability is critical.