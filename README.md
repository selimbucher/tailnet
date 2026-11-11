# tailnet

Headscale control server for my machines, as a NixOS module.

```nix
services.tailnet.enable = true;
```

## Add a machine

On the server:

```sh
headscale users create selim   # once
headscale users list           # note the ID
headscale preauthkeys create --user <ID> --expiration 1h
```

`<ID>`: the user's ID from `headscale users list`.

On the machine:

```sh
sudo tailscale up --login-server https://tailnet.selim.one --auth-key <KEY>
```

`<KEY>`: the key printed by `preauthkeys create`.

Back on the server, the machine and its 100.64.x.y address:

```sh
headscale nodes list
```
