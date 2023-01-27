#!/bin/bash

echo -e "\033[32m runsvdir-start & \033[0m"
/opt/gitlab/embedded/bin/runsvdir-start &

echo -e "\033[32m reconfigure \033[0m"
echo -e "\n127.0.0.1 mygitlab.ru" >> /etc/hosts
echo "gitlab_rails['initial_root_password'] = \"mdulciemhufflep\"" > /etc/gitlab/gitlab.rb
echo "external_url 'https://mygitlab.ru'" >> /etc/gitlab/gitlab.rb

gitlab-ctl reconfigure

echo -e "\033[32m wrapper \033[0m"
/assets/wrapper
