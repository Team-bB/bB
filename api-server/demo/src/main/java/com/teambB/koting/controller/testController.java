package com.teambB.koting.controller;

import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
public class testController {

  @PostMapping("/test")
  public void testMapping() {
    System.out.println("1");
  }
}
