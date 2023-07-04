FROM alpine:3.15.0

RUN apk --update add freeradius freeradius-mysql freeradius-utils

ENV DB_HOST=0.0.0.0
ENV DB_PORT=3306
ENV DB_DATABASE=radius
ENV DB_USERNAME=radius
ENV DB_PASSWORD=radpass
ENV RADIUS_CLIENT=0.0.0.0
ENV RADIUS_SECRET=testing123
ENV RADIUS_LOG_AUTH=no

COPY raddb/radiusd.conf /etc/raddb/radiusd.conf
COPY raddb/clients.conf /etc/raddb/clients.conf
COPY raddb/sql /etc/raddb/mods-available/sql
COPY raddb/default /etc/raddb/sites-available/default
COPY raddb/inner-tunnel /etc/raddb/sites-available/inner-tunnel

RUN chown -R root:radius /etc/raddb
RUN chmod go-w /etc/raddb/radiusd.conf
RUN chmod go-w /etc/raddb/clients.conf
RUN chmod go-w /etc/raddb/mods-available/sql
RUN chmod go-w /etc/raddb/sites-available/default
RUN chmod go-w /etc/raddb/sites-available/inner-tunnel

COPY script/start.sh /start.sh
RUN chmod +x /start.sh

EXPOSE 1812/udp 1813/udp

ENTRYPOINT ["./start.sh"]
# ENTRYPOINT ["tail"]
# CMD ["-f","/dev/null"]