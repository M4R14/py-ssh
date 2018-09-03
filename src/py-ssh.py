#!/usr/bin/env python3
import sys
import fire
import paramiko
import json

def deploy(host, user, password, dir, command):
  _command = command;
  _host = host;
  _username = user;
  _password = password;
  _dir = dir;

  client = paramiko.SSHClient();
  client.load_system_host_keys();
  client.set_missing_host_key_policy(paramiko.AutoAddPolicy());
  client.connect(
    _host,
    username=_username,
    password=_password
  );
  cd_dir = "cd %s; " % _dir;
  command_list = command.split('\n');
  for cmd in command_list:
    if cmd == '':
      continue;
    print("[command]: %s" % cmd);
    stdin, stdout, stderr = client.exec_command(cd_dir + cmd);
    exit_status = stdout.channel.recv_exit_status();
    if exit_status == 0:
      print('[success]: %s' % stdout.read().decode("utf-8"));
    else:
      print("[status] %s" % exit_status);
      sys.exit('[error]: %s' % stderr.read().decode("utf-8"));

class deployer(object):
  def __init__(self, servername, command):
    filejson = 'py-ssh.json';
    severHost = json.load(open(filejson));
    servers = severHost['server'];

    for server in servers:
      if (server['server_name'] == servername):
        self.__server = server;
        break

    self.__run(command);

  def __run(self, command):
    server = self.__server
    deploy(
      server['host'],
      server['user'],
      server['password'],
      server['dir'],
      command
    );

if __name__ == '__main__':
  fire.Fire(deployer);