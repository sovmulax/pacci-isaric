FROM ubuntu:22.04

# Set noninteractive installation to avoid prompts
ENV PYTHONDONTWRITEBYTECODE 1
ENV PYTHONUNBUFFERED 1
ARG DEBIAN_FRONTEND=noninteractive

WORKDIR /app

# Update package repository and install required packages
RUN apt-get update && \
    apt-get install -y python3 python3-pip gcc g++ \
    libldap2-dev libsasl2-dev libssl-dev curl netcat nano

# Upgrade pip and install gunicorn
RUN pip3 install --upgrade pip && pip3 install gunicorn

# Copier les fichiers de dépendances
COPY requirements.txt .

# Installer les dépendances Python
RUN pip3 install -r requirements.txt

# Copier le reste du code de l'application
COPY . .

# Exposer le port sur lequel l'application s'exécute
EXPOSE 8300

# Commande pour démarrer l'application avec enhanced error handling
# Added --timeout to prevent worker becoming unusable
# Added --workers 3 to allow for worker redundancy
# Added --max-requests and --max-requests-jitter to prevent memory leaks
# CMD ["gunicorn", "--bind", "0.0.0.0:8000", "--workers", "3", "--timeout", "120", "--max-requests", "1000", "--max-requests-jitter", "50", "app:app"]
CMD ["python3", "app.py"]