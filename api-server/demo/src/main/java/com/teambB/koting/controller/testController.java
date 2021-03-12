package com.teambB.koting.controller;

import com.teambB.koting.domain.MemberTest;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RestController;


@RestController
public class testController {

  @PostMapping("/")
  public Object testMapping(@RequestBody Object params) {
    return params;
  }

  @GetMapping("/")
  public MemberTest memberGetTest() {
    return new MemberTest(0L, "Jongho Han", "is GetMan");
  }

  @PostMapping("/")
  public MemberTest memberPostTest() {
    return new MemberTest(0L, "Jongho Han", "is PostMan");
  }
}

