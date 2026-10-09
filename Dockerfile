FROM nginx:1.25-alpine

# Remove a configuração padrão do Nginx
RUN rm /etc/nginx/conf.d/default.conf

# Copia a nossa configuração customizada para o contêiner
COPY nginx.conf /etc/nginx/nginx.conf

# Expõe a porta 80 para tráfego público
EXPOSE 80

# Executa o Nginx em primeiro plano
CMD ["nginx", "-g", "daemon off;"]