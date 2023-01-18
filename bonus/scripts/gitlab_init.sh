#!/bin/bash

echo -e "\033[32m runsvdir-start & \033[0m"
/opt/gitlab/embedded/bin/runsvdir-start &

echo -e "\033[32m reconfigure \033[0m"
echo "external_url 'http://localhost:8886'" > /etc/gitlab/gitlab.rb && \
echo "gitlab_rails['initial_root_password'] = \"mdulciemhufflep\"" >> /etc/gitlab/gitlab.rb
gitlab-ctl reconfigure

echo -e "\033[32m wrapper \033[0m"
/assets/wrapper