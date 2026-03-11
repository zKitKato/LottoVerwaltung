```mermaid
graph TD
    subgraph Internet ["Externes Internet"]
        RemotePC["Externer Rechner (Home Office/Mobil)"]
    end

    subgraph Heimnetz ["Privates Heimnetzwerk (LAN)"]
        subgraph ServerHost ["Debian 13 Server (Docker Host)"]
            subgraph DockerStack ["Docker Stack (Docker Compose)"]
                App["Web Applikation (Port 8080)"]
                DB[("Datenbank")]
                Docs["Docusaurus (Port 3000)"]
            end
            VPN["VPN Dienst (WireGuard / Tailscale)"]
        end
        LocalPC["Lokaler Rechner (LAN)"]
    end

%% Kommunikationswege
    RemotePC -- " 1. Sicherer VPN Tunnel " --> VPN
    VPN -- " 2. Zugriff auf App & Docs " --> DockerStack
    LocalPC -- " Direkter LAN Zugriff " --> App
    LocalPC -- " Dokumentation lesen " --> Docs
    App <--> DB
%% Styles
    style RemotePC fill: #ff, stroke: #ff0000, stroke-width: 2px
    style VPN fill: #ff, stroke: #00aa00, stroke-width: 2px
    style App fill: #bb, stroke: #333, stroke-width: 2px
    style Docs fill: #f9, stroke: #333, stroke-width: 2px
```

## Credits to:

- [Bootstrap Template SB-Admin-2](https://startbootstrap.com/theme/sb-admin-2)
- [Github SB-Admin-2](https://github.com/StartBootstrap/startbootstrap-sb-admin-2/tree/master)
- [AwesomeFonts-Free Package](https://rfontawesome.com/search)
- [Springboot](https://docs.spring.io/spring-boot/index.html)
- [Maven](https://maven.apache.org/guides/)
- [JSP - JavaServerPages](https://docs.oracle.com/javaee/5/tutorial/doc/bnajo.html)
- [Docker Compose](https://docs.docker.com/compose/)
- [Dockerfile](https://docs.docker.com/build/concepts/dockerfile/)
- [Bash Script](https://www.freecodecamp.org/news/shell-scripting-crash-course-how-to-write-bash-scripts-in-linux/)
- AI: Gemini, Perplexity, ChatGPT
- StackOverflow