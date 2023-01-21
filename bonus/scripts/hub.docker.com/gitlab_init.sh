#!/bin/bash

echo -e "\033[32m runsvdir-start & \033[0m"
/opt/gitlab/embedded/bin/runsvdir-start &

echo -e "\033[32m reconfigure \033[0m"
# echo "external_url 'http://localhost:8886'" > /etc/gitlab/gitlab.rb && \
echo -e "\n127.0.0.1 mygitlab.ru" >> /etc/hosts
echo "external_url 'https://mygitlab.ru'" > /etc/gitlab/gitlab.rb && \
echo "gitlab_rails['initial_root_password'] = \"mdulciemhufflep\"" >> /etc/gitlab/gitlab.rb
# echo "nginx['redirect_http_to_https'] = true" >> /etc/gitlab/gitlab.rb
# echo "letsencrypt['enable'] = false" >> /etc/gitlab/gitlab.rb
# mkdir -p /etc/gitlab/ssl
# chmod 755 /etc/gitlab/ssl

gitlab-ctl reconfigure

echo -e "\033[32m wrapper \033[0m"
/assets/wrapper
