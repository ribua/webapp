# 1. Base Image
FROM registry.access.redhat.com/hi/httpd:latest

LABEL description="RHEL 9 Web Server for OpenShift"

# 2. Install Apache
RUN dnf -y install httpd && dnf clean all

# Remove RHEL "test page" / welcome handling so / serves /var/www/html (incl. index.html)
RUN rm -f /etc/httpd/conf.d/welcome.conf

# 3. Change Port to 8080 (Non-root requirement)
RUN sed -i 's/Listen 80/Listen 8080/' /etc/httpd/conf/httpd.conf

# 4. Copy your index.html from Git into the image
# This takes index.html from your repo and puts it in Apache's document root
COPY index.html /var/www/html/

# 5. Fix Permissions
# We do this AFTER the copy to ensure index.html is readable/writable by the group
RUN chgrp -R 0 /var/log/httpd /var/run/httpd /var/www/html && \
    chmod -R g=u /var/log/httpd /var/run/httpd /var/www/html

# 6. Expose Port
EXPOSE 8080

# 7. Switch User
USER 1001

# 8. Start
CMD ["/usr/sbin/httpd", "-D", "FOREGROUND"]
