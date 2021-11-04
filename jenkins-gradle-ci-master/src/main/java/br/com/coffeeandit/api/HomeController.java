package br.com.coffeeandit.api;

import org.springframework.beans.factory.annotation.Value;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.client.RestTemplate;

@RestController
public class HomeController {


    private RestTemplate restTemplate = new RestTemplate();

    @Value("${app.version}")
    private String version;

    @GetMapping(path = "/", produces = MediaType.TEXT_HTML_VALUE)
    public ResponseEntity<String> home() {

        return ResponseEntity.ok("Olá CoffeeAndIT vocẽ chegou aqui! Seja bem-vindo!");

    }

    @GetMapping(path = "/version", produces = MediaType.TEXT_HTML_VALUE)
    public ResponseEntity<String> version() {

        return ResponseEntity.ok(version);

    }

    @GetMapping(path = "/get", produces = MediaType.APPLICATION_JSON_VALUE)
    public ResponseEntity<String> httpBin() {
        return restTemplate.getForEntity("http://35.229.58.199/get", String.class);

    }
}
