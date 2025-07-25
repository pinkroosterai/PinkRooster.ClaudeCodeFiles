# Clean Project

Remove build artifacts, temporary files, test results, and other generated content from .NET projects.

## Context Gathering

!ls -la
!find . -name "bin" -type d 2>/dev/null | head -10
!find . -name "obj" -type d 2>/dev/null | head -10
!find . -name "TestResults" -type d 2>/dev/null | head -5
!du -sh bin/ obj/ TestResults/ 2>/dev/null || echo "No major build artifacts found"

## Analysis Phase

### Identify Cleanup Targets
- **Build Output**: bin/, obj/ directories
- **Test Results**: TestResults/ directories, *.trx files
- **IDE Files**: *.user files, .vs/ directories
- **Package Cache**: packages/ directories (legacy)
- **Logs**: *.log files, log*.txt files
- **Temporary**: *.tmp, *.temp files
- **Backup Files**: *.bak files
- **Coverage**: *.coverage files

### Safety Checks
Before cleaning, verify:
- No important uncommitted changes
- No custom files in standard directories
- Project builds successfully after clean

## Implementation Phase

### Clean Build Artifacts
```bash
# Remove bin and obj directories
find . -name "bin" -type d -exec rm -rf {} + 2>/dev/null || true
find . -name "obj" -type d -exec rm -rf {} + 2>/dev/null || true
echo "✓ Removed build output directories"

# Remove test results
find . -name "TestResults" -type d -exec rm -rf {} + 2>/dev/null || true
find . -name "*.trx" -type f -delete 2>/dev/null || true
echo "✓ Removed test results"

# Remove IDE and user files
find . -name "*.user" -type f -delete 2>/dev/null || true
find . -name ".vs" -type d -exec rm -rf {} + 2>/dev/null || true
echo "✓ Removed IDE temporary files"

# Remove package directories (legacy)
find . -name "packages" -type d -exec rm -rf {} + 2>/dev/null || true
echo "✓ Removed legacy package directories"

# Remove log files
find . -name "*.log" -type f -delete 2>/dev/null || true
find . -name "log*.txt" -type f -delete 2>/dev/null || true
echo "✓ Removed log files"

# Remove temporary and backup files
find . -name "*.tmp" -type f -delete 2>/dev/null || true
find . -name "*.temp" -type f -delete 2>/dev/null || true
find . -name "*.bak" -type f -delete 2>/dev/null || true
find . -name "*.coverage" -type f -delete 2>/dev/null || true
echo "✓ Removed temporary and backup files"
```

### Optional: Deep Clean
For thorough cleaning, also remove:
```bash
# NuGet cache (global - use with caution)
# dotnet nuget locals all --clear

# Remove node_modules if present (for mixed projects)
find . -name "node_modules" -type d -exec rm -rf {} + 2>/dev/null || true
echo "✓ Removed node_modules directories"
```

## Validation Phase

### Verify Cleanup
```bash
echo "=== Cleanup Summary ==="
echo "Remaining build artifacts:"
find . -name "bin" -o -name "obj" -o -name "TestResults" 2>/dev/null | wc -l
echo "Remaining temporary files:"
find . -name "*.user" -o -name "*.tmp" -o -name "*.log" 2>/dev/null | wc -l

echo "=== Directory Sizes After Cleanup ==="
du -sh . 2>/dev/null || echo "Size calculation unavailable"
```

### Test Build (Optional)
```bash
if [ -f "*.sln" ]; then
    echo "Testing build after cleanup..."
    dotnet build --no-restore --verbosity quiet
    if [ $? -eq 0 ]; then
        echo "✓ Project builds successfully after cleanup"
    else
        echo "⚠ Build issues detected - check for missing dependencies"
    fi
fi
```

## Error Handling

- **Permission Denied**: Some files may be locked by IDE or running processes
- **Build Failures**: Ensure NuGet packages are restored after cleanup
- **Missing Directories**: Ignore errors for non-existent paths

## Usage Examples

```bash
# Basic project cleanup
/clean-project

# With build verification
/clean-project && dotnet restore && dotnet build

# Check what would be removed (dry run)
find . -name "bin" -o -name "obj" -o -name "TestResults" -o -name "*.user" -o -name "*.log"
```

## Integration Notes

- Safe to run multiple times
- Preserves source code and configuration files
- Works with solution and project directories
- Compatible with CI/CD pipelines

---

**Tools**: Bash
**Category**: Project Maintenance
**Complexity**: Low-Medium
**Safety**: High (only removes generated files)