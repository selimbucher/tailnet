# Headscale, the control server for a tailnet joined with the stock Tailscale
# client. TLS and public exposure via the host's Caddy. Relays and NAT
# traversal use Tailscale's public DERP servers; traffic stays end-to-end
# WireGuard.
{ config, lib, ... }:
let
  cfg = config.services.tailnet;
in
{
  options.services.tailnet = {
    enable = lib.mkEnableOption "Headscale tailnet control server";

    domain = lib.mkOption {
      type = lib.types.str;
      default = "tailnet.selim.one";
      description = "Public domain Caddy serves Headscale on, the clients' --login-server.";
    };

    port = lib.mkOption {
      type = lib.types.port;
      default = 8793;
      description = "Localhost port Headscale listens on (Caddy proxies to it).";
    };
  };

  config = lib.mkIf cfg.enable {
    services.headscale = {
      enable = true;
      address = "127.0.0.1";
      port = cfg.port;
      settings = {
        server_url = "https://${cfg.domain}";
        # Clients keep their own resolvers; machines name each other in /etc/hosts.
        dns = {
          magic_dns = false;
          override_local_dns = false;
        };
      };
    };

    services.caddy.virtualHosts.${cfg.domain}.extraConfig = ''
      log {
        output file /var/log/caddy/access-${cfg.domain}.log
      }
      reverse_proxy 127.0.0.1:${toString cfg.port}
    '';
  };
}
