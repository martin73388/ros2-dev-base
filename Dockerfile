# Utilisation de l'image officielle de ROS2 (Jazzy)
FROM osrf/ros:jazzy-desktop-full

# Passer en root pour installer sudo et créer l'utilisateur
USER root
RUN apt-get update && apt-get install -y sudo && rm -rf /var/lib/apt/lists/*

# Définir les arguments pour notre utilisateur
# === CORRECTION ===
# On utilise 1001 pour éviter le conflit avec l'utilisateur 1000 existant
ARG USERNAME=rosuser
ARG USER_UID=1001
ARG USER_GID=1001

# 1. Créer un nouveau groupe 'rosuser' (GID 1001)
RUN groupadd --gid $USER_GID $USERNAME
    
# 2. Créer un nouvel utilisateur 'rosuser' (UID 1001) et l'ajouter au groupe 'sudo'
RUN useradd -m -s /bin/bash --uid $USER_UID --gid $USER_GID -G sudo $USERNAME
    
# 3. Donner à cet utilisateur les permissions sudo sans mot de passe
RUN echo "$USERNAME ALL=(ALL) NOPASSWD:ALL" > /etc/sudoers.d/$USERNAME

# Basculer vers notre nouvel utilisateur 'rosuser'
USER $USERNAME

# Définir l'environnement de travail pour 'rosuser'
ENV HOME /home/$USERNAME
WORKDIR /home/$USERNAME/ros2_ws

# Installer les outils de développement (en tant que 'rosuser' avec 'sudo')
RUN sudo apt-get update && sudo apt-get install -y \
    python3-pip \
    python3-colcon-common-extensions \
    git \
    nano \
    # Vos dépendances de projet
    ros-jazzy-rosbridge-suite \
    ros-jazzy-tf2-ros \
    ros-jazzy-message-filters \
    && sudo rm -rf /var/lib/apt/lists/*

# Configurer le bashrc pour 'rosuser'
RUN echo "source /opt/ros/jazzy/setup.bash" >> /home/$USERNAME/.bashrc \
    && echo "source /home/$USERNAME/ros2_ws/install/setup.bash" >> /home/$USERNAME/.bashrc

# Créer la structure du workspace
RUN mkdir -p /home/$USERNAME/ros2_ws/src