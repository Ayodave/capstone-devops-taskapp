# Contributing Guidelines

## Getting Started

1. Fork the repository
2. Clone your fork
3. Create a feature branch
   git checkout -b feat/your-feature-name

## Branch Naming

- feat/description - new features
- fix/description - bug fixes
- docs/description - documentation
- chore/description - maintenance

## Commit Messages

Follow conventional commits format:
- feat: add new feature
- fix: fix a bug
- docs: update documentation
- chore: maintenance task
- refactor: code refactoring

## Pull Request Process

1. Update CHANGELOG.md with your changes
2. Ensure CI pipeline passes
3. Request review from maintainer
4. Squash commits before merging

## Code Standards

### Terraform
- Run terraform fmt before committing
- Run terraform validate before committing
- Add comments for complex resources

### Kubernetes
- Always set resource requests and limits
- Always set health probes
- Never commit real secrets

### Shell Scripts
- Use set -e at the top
- Add comments for complex commands
- Test locally before committing

## Security

- Never commit credentials or secrets
- Use Sealed Secrets for K8s secrets
- Use AWS IAM roles not access keys where possible
- Use AWS IAM roles not access keys where possible
- Report security issues privately to maintainer
