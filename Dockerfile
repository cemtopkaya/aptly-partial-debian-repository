FROM debian:stable-slim

# Gerekli araçları kuruyoruz
RUN apt-get update \
 && apt-get install -y \
               apt-rdepends \
               aptitude \
               aptly \
               nginx 
# && rm -rf /var/lib/apt/lists/*

#USER root
# Depo dizinlerini oluşturuyoruz
#RUN mkdir -p /opt/{repo,config}

# aptly yapılandırması
#COPY ./aptly.conf /opt/config/aptly.conf

# Paket indirme ve APT deposu oluşturma scripti
#COPY ./create-repo.sh /opt/create-repo.sh
#RUN chmod +x /opt/create-repo.sh

# nginx yapılandırması
#RUN echo 'server {\n\
#     listen 80;\n\
#     root /opt/repo/public;\n\
#     autoindex on;\n\
#}\n' > /etc/nginx/sites-available/default

# Çalışma dizini
#WORKDIR /root/.aptly

# Depoyu başlatma
#CMD ["/root/create-repo.sh"]
