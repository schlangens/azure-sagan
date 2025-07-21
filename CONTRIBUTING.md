# Contributing to Azure Sagan

Thank you for your interest in contributing to this project! This document provides guidelines for contributing to the Azure Sagan automated security testing environment.

## Getting Started

1. Fork the repository on GitHub
2. Clone your fork locally
3. Set up the development environment following the README instructions
4. Create a new branch for your feature or bug fix

## Development Setup

### Prerequisites
Ensure you have all the tools listed in the README.md installed:
- Azure CLI
- Terraform
- Python 3 and pip
- Ansible (via requirements.txt)

### Environment Setup
```bash
# Install Python dependencies
pip3 install -r requirements.txt

# Generate SSH key if needed
ssh-keygen -t rsa -b 4096 -f ~/.ssh/id_rsa

# Login to Azure
az login
```

## Testing Your Changes

Before submitting a pull request, please test your changes:

### 1. Test Deployment
```bash
./scripts/deploy.sh
```

### 2. Verify Services
- SSH into the VM
- Check Sagan and Suricata service status
- Review logs for errors

### 3. Test Teardown
```bash
./scripts/teardown.sh
```

### 4. Verify Cleanup
```bash
az group list --query "[?name=='rg-azure-sagan-test']"
```
Should return an empty array `[]`

## Contribution Guidelines

### Code Style
- Follow existing code formatting and naming conventions
- Use descriptive variable names in Terraform and Ansible
- Add comments for complex logic
- Keep Ansible playbooks idempotent

### Documentation
- Update README.md if adding new features
- Document any new configuration options
- Include usage examples for new functionality

### Security
- Never commit SSH keys, passwords, or other credentials
- Use Azure Key Vault or environment variables for sensitive data
- Follow the principle of least privilege in IAM configurations
- Ensure all resources are properly tagged

### File Structure
```
azure-sagan/
├── terraform/          # Infrastructure as Code
├── ansible/            # Configuration Management
│   ├── playbooks/      # Ansible playbooks
│   └── templates/      # Configuration templates
├── scripts/            # Automation scripts
└── docs/              # Additional documentation (if needed)
```

## Types of Contributions

### Bug Fixes
- Search existing issues before creating a new one
- Provide clear reproduction steps
- Include error messages and logs
- Test the fix thoroughly

### New Features
- Open an issue to discuss the feature first
- Ensure the feature aligns with project goals
- Update documentation
- Add appropriate tests

### Infrastructure Improvements
- Optimize resource usage
- Improve security configurations
- Enhance monitoring and logging
- Cost optimization

### Documentation
- Fix typos and clarify instructions
- Add troubleshooting guides
- Improve setup instructions
- Add architecture diagrams

## Pull Request Process

1. **Create a Feature Branch**
   ```bash
   git checkout -b feature/your-feature-name
   ```

2. **Make Your Changes**
   - Follow the coding standards
   - Test thoroughly
   - Update documentation

3. **Commit Your Changes**
   ```bash
   git add .
   git commit -m "Description of changes"
   ```

4. **Push to Your Fork**
   ```bash
   git push origin feature/your-feature-name
   ```

5. **Create a Pull Request**
   - Use a clear, descriptive title
   - Explain what changes you made and why
   - Reference any related issues
   - Include testing steps

### Pull Request Template
```markdown
## Description
Brief description of changes

## Type of Change
- [ ] Bug fix
- [ ] New feature
- [ ] Breaking change
- [ ] Documentation update

## Testing
- [ ] Tested deployment script
- [ ] Verified services start correctly
- [ ] Tested teardown script
- [ ] Verified complete resource cleanup

## Checklist
- [ ] Code follows project style guidelines
- [ ] Self-review completed
- [ ] Documentation updated
- [ ] No sensitive information included
```

## Security Considerations

### Reporting Security Issues
If you discover a security vulnerability, please:
1. **Do NOT** open a public issue
2. Email the maintainers directly
3. Provide detailed information about the vulnerability
4. Allow time for the issue to be addressed before public disclosure

### Security Best Practices
- Use latest versions of tools and dependencies
- Follow Azure security best practices
- Implement proper access controls
- Regularly review and update dependencies

## Code Review Process

All contributions go through code review:
1. Maintainers will review your pull request
2. Feedback may be provided for improvements
3. Once approved, changes will be merged
4. Credit will be given in the commit history

## Community Guidelines

- Be respectful and inclusive
- Help others learn and grow
- Provide constructive feedback
- Focus on the technical aspects of contributions

## Getting Help

If you need help:
1. Check the README.md troubleshooting section
2. Search existing issues
3. Create a new issue with detailed information
4. Tag maintainers if urgent

## Recognition

Contributors will be recognized in:
- Commit history
- Release notes
- Contributors section (if added)

Thank you for contributing to making this project better!