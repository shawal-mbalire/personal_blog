#!/bin/bash

# Project Name
PROJECT_NAME="personal_blog"

# Create Project Directory
echo "Creating project directory: $PROJECT_NAME"
mkdir "$PROJECT_NAME" || { echo "Error: Could not create directory."; exit 1; }
cd "$PROJECT_NAME"

# Create Backend Directory
echo "Creating backend directory: blog_backend"
mkdir blog_backend || { echo "Error: Could not create directory."; exit 1; }
cd blog_backend

# Create Python Virtual Environment
echo "Creating virtual environment: .venv"
python3 -m venv .venv || { echo "Error: Could not create virtual environment."; exit 1; }

# Activate Virtual Environment
source .venv/bin/activate || { echo "Error: Could not activate virtual environment."; exit 1; }

# Install pip if not found - some systems may require this
if ! command -v pip &> /dev/null
then
  echo "pip not found. Installing..."
  python -m ensurepip --upgrade || { echo "Error: Could not install pip"; exit 1; }
fi


# Install Django *inside* the virtual environment
echo "Installing Django..."
pip install django || { echo "Error: Could not install Django."; exit 1; }

# Create Django Project (using "." for current directory)
echo "Creating Django project..."
django-admin startproject blog_backend . || { echo "Error: Could not create Django project."; exit 1; }

# Create Django App
echo "Creating Django app: blog"
python manage.py startapp blog || { echo "Error: Could not create Django app."; exit 1; }

# Create requirements.txt (empty initially)
echo "Creating requirements.txt"
touch requirements.txt || { echo "Error: Could not create requirements.txt"; exit 1; }

# Deactivate Virtual Environment (good practice after installing Django)
deactivate

# Create Frontend Directory (outside the venv)
cd ..
echo "Creating frontend directory: blog_frontend"
mkdir blog_frontend || { echo "Error: Could not create directory."; exit 1; }
cd blog_frontend

# Create Angular Project
echo "Creating Angular project..."
ng new blog-frontend --style=scss --routing --skip-tests || { echo "Error: Could not create Angular project."; exit 1; }

# Create Docker Compose File (in the root directory)
cd ..
echo "Creating docker-compose.yml"
cat <<EOF > docker-compose.yml || { echo "Error: Could not create docker-compose.yml"; exit 1; }
version: "3.9"

services:
  web:
    build: ./blog_backend
    ports:
      - "8000:8000"
    volumes:
      - ./blog_backend:/app
    depends_on:
      - db
    environment:
      - POSTGRES_NAME=blog_db
      - POSTGRES_USER=blog_user
      - POSTGRES_PASSWORD=blog_password
      - POSTGRES_HOST=db

  db:
    image: postgres:14
    ports:
      - "5432:5432" # Only expose if needed externally
    environment:
      - POSTGRES_DB=blog_db
      - POSTGRES_USER=blog_user
      - POSTGRES_PASSWORD=blog_password
    volumes:
      - db_data:/var/lib/postgresql/data

  frontend:
    build: ./blog_frontend
    ports:
      - "4200:4200"
    depends_on:
      - web
    volumes:
        - ./blog_frontend:/app
        - /app/node_modules
    command: ng serve --host 0.0.0.0

volumes:
  db_data:
EOF

# Create initial files/folders in Django app (blog)
cd blog_backend
echo "Creating initial Django app files..."
mkdir -p blog/templates blog/static || { echo "Error: Could not create Django app directories."; exit 1; }
touch blog/models.py blog/serializers.py blog/views.py blog/urls.py || { echo "Error: Could not create Django app files."; exit 1; }

# Create initial files/folders in Angular app (blog_frontend/src/app)
cd ../../blog_frontend
echo "Creating initial Angular app files..."
mkdir -p src/app/components src/app/services || { echo "Error: Could not create Angular app directories."; exit 1; }
touch src/app/app.module.ts src/app/app-routing.module.ts src/app/components/post-list/post-list.component.ts src/app/components/post-detail/post-detail.component.ts src/app/services/blog.service.ts || { echo "Error: Could not create Angular app files."; exit 1; }


# Initialize Git Repository (Optional, but highly recommended)
cd ..
echo "Initializing Git repository..."
git init || { echo "Error: Could not initialize Git repository."; exit 1; }
git add . || { echo "Error: Could not add files to Git."; exit 1; }
git commit -m "Initial commit" || { echo "Error: Could not commit to Git."; exit 1; }

echo "Project setup complete!"
echo "Next steps:"
echo "1. Activate virtual environment: source blog_backend/.venv/bin/activate"
echo "2. Add Python packages to blog_backend/requirements.txt (e.g., djangorestframework, psycopg2-binary)"
echo "3. Install Python dependencies: pip install -r blog_backend/requirements.txt"
echo "4. Install Node.js dependencies: cd blog_frontend && npm install"
echo "5. Configure Django settings (blog_backend/blog_backend/settings.py)"
echo "6. Define Django models, serializers, and views (blog_backend/blog/)"
echo "7. Develop Angular components and services (blog_frontend/src/app/)"
echo "8. Run with Docker Compose: docker-compose up -d"