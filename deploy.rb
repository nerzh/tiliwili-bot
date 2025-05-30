#!/usr/bin/env ruby

current_file_path = File.expand_path(File.dirname(__FILE__))
ssh_key_name = "botasbot.bytehub.io"
app_name = "tiliwili"
system("eval \"$(ssh-agent -s)\" || true && ssh-add ~/.ssh/#{ssh_key_name}.pub || true && ssh-add ~/.ssh/#{ssh_key_name} || true && git reset --hard HEAD || true && git pull origin master")
#system("swift package resolve")
system("swift package update")
system("swift build -c release -Xswiftc -Ounchecked -Xswiftc -whole-module-optimization -Xcc -O2")
system("sudo systemctl start #{app_name}")
system("sudo pkill -9 -f #{app_name}")
system("sudo systemctl start #{app_name}")
# system("/home/devton/swift/#{name}/.build/release/#{name} --env production > /home/devton/swift/#{name}/log.txt 2>&1 &")
