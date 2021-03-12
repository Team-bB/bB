package com.teambB.koting.controller;

import com.teambB.koting.domain.MemberTest;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;


@RestController
public class testController {

  @PostMapping("/test")
  public String testMapping(@RequestParam("id") String id, @RequestParam("pw") String pw) {
    String tmp = "id: " + id + " pw: "+ pw + " 잘 받았습니다 ^___^";
    return tmp;
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

