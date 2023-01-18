FROM gitlab/gitlab-ce:latest

COPY ./gitlab_init.sh /gitlab_init.sh
RUN chmod 777 /gitlab_init.sh
CMD ["/gitlab_init.sh"]
    