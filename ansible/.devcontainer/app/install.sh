#!/bin/bash

# プロジェクト名を環境変数から取得（未定義なら sample）
PROJECT_NAME="${PROJECT_NAME:-sample}"

if [ -d "$PROJECT_NAME" ]; then
  echo "❗️Directory '$PROJECT_NAME' already exists. Skipping creation."
else
  echo "📁 Creating Flask project directory: $PROJECT_NAME"
  mkdir "$PROJECT_NAME"
  cd "$PROJECT_NAME" || exit 1

  echo "🐍 Creating virtual environment..."
  python3 -m venv venv

  echo "⚙️ Activating virtual environment and installing Flask..."
  source venv/bin/activate
  pip install --upgrade pip
  pip install flask

  echo "📝 Saving dependencies to requirements.txt"
  pip freeze > requirements.txt

  echo "🛠 Setting up VS Code settings"
  mkdir -p .vscode
  cat > .vscode/settings.json <<EOF
{
  "python.defaultInterpreterPath": "\${workspaceFolder}/venv/bin/python"
}
EOF

  echo "🧩 Creating VS Code workspace file"
  cat > "../${PROJECT_NAME}.code-workspace" <<EOF
{
  "folders": [
    {
      "path": "$PROJECT_NAME"
    }
  ],
  "settings": {
    "python.defaultInterpreterPath": "\${workspaceFolder}/venv/bin/python",
    "terminal.integrated.defaultProfile.linux": "bash"
  }
}
EOF

  echo "🧾 Creating default app.py"
  cat > app.py <<EOF
from flask import Flask

app = Flask(__name__)

@app.route("/")
def hello():
    return "Hello, Flask!"
EOF

  echo "✅ Flask project initialized in '$PROJECT_NAME'."
fi