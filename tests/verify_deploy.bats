#!/usr/bin/env bats

@test "Juju controllers.yaml created" {
  [ -f ~/.local/share/juju/controllers.yaml ]
  [ "$(cat ~/.local/share/juju/controllers.yaml)" = "mock_controller_config" ]
}

@test "Juju accounts.yaml created" {
  [ -f ~/.local/share/juju/accounts.yaml ]
  run grep "user: mock_user" ~/.local/share/juju/accounts.yaml
  [ "$status" -eq 0 ]
  run grep "password: mock_password" ~/.local/share/juju/accounts.yaml
  [ "$status" -eq 0 ]
}

@test "Vault login called" {
  run grep "approle/login" ~/mocks/vault.log
  [ "$status" -eq 0 ]
}

@test "Vault secrets read" {
  run grep -A 1 "read.*controllers" ~/mocks/vault.log
  [ "$status" -eq 0 ]
  run grep -A 1 "read.*juju" ~/mocks/vault.log
  [ "$status" -eq 0 ]
}

@test "Juju refresh called" {
  run grep "refresh test-app" ~/mocks/juju.log
  [ "$status" -eq 0 ]
}

@test "Snap installs called" {
  run grep "install --channel=3.1 juju" ~/mocks/snap.log
  [ "$status" -eq 0 ]
  run grep "install --classic vault" ~/mocks/snap.log
  [ "$status" -eq 0 ]
}
