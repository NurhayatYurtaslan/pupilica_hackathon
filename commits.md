# 📜 Commit Message Guideline

We follow **one strict rule** for all commit messages. No exceptions, no optional parts. Every commit must follow this exact structure:

---

## 📌 Commit Format

```
<emoji> <type>(scope): <summary>

<body>

<footer>
```

### 📝 Example

```
✨ feat(auth): add user login page

Implemented a new login form with validation. This allows users to
sign in using email and password.

Closes #42
```

---

## 🎯 Commit Types & Emojis

* ➕ **add**: add new things
* ✨ **feat**: A new feature
* 🐛 **fix**: A bug fix
* 📖 **docs**: Documentation changes
* 🎨 **style**: Code style changes (no logic)
* 🔨 **refactor**: Code restructuring without behavior change
* ⚡ **perf**: Performance improvements
* 🧪 **test**: Adding or updating tests
* 📦 **chore**: Maintenance tasks (build, deps, tooling)
* 🚀 **deploy**: Deployment-related changes
* 🔒 **security**: Security fixes
* 🤖 **ci**: CI/CD configuration changes
* ⚙️ **config**: Configuration changes
* 🔀 **merge**: Merging branches
* ⏪ **revert**: Reverting a commit
* 🔖 **release**: Version or release tagging
* 🌍 **i18n**: Internationalization/localization
* 🖼️ **ui**: UI/UX updates
* 📊 **analytics**: Analytics or tracking changes
* 🗃️ **db**: Database-related changes
* 🧹 **cleanup**: Remove unused code/files
* 🔬 **experiment**: Experimental code
* 🚨 **hotfix**: Urgent production fix

---

## 📂 Body

* Always explain **what changed and why**.
* Use imperative mood ("add" not "added").
* Wrap text at \~72 characters per line.

---

💡 **Rule:** Every commit must follow this full structure. **No optional parts.**
