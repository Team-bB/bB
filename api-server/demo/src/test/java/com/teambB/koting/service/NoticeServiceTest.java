package com.teambB.koting.service;

import static org.junit.Assert.*;

import com.teambB.koting.domain.Notice;
import org.junit.Test;
import org.junit.runner.RunWith;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.test.context.junit4.SpringRunner;
import org.springframework.transaction.annotation.Transactional;

@RunWith(SpringRunner.class)
@SpringBootTest
@Transactional
public class NoticeServiceTest {

  @Autowired NoticeService noticeService;

  @Test
  public void 공지생성() throws Exception {
      //given
    Notice notice = Notice.createNotice("제목 테스트", "내용 테스트");

      //when
    Long id = noticeService.join(notice);

    //then
    assertEquals(notice, noticeService.findOne(id));
  }
}