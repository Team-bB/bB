package com.teambB.koting.service;

import static org.junit.Assert.*;

import com.teambB.koting.domain.Notice;
import com.teambB.koting.firebase.FirebaseCloudMessageService;
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

  @Test
  public void 알람테스트() throws Exception {
      //given
    FirebaseCloudMessageService firebaseCloudMessageService = new FirebaseCloudMessageService();
    firebaseCloudMessageService.sendMessageTo("e7b-CPJ6D0Odso8I27WgWh:APA91bGQg3ilrMTqvDoypdNvX-yq_QDpaB5p9j-89gGtIw9kqJx9PtEoknAAV7le0rO3C3O2flrC0TxseaWqHNVcvs26MeZwXrl-MUfNinJaIKqIXOlyQT8xQINiTX6_dhVmsVHiohHs"
        , "정우형", "이제 초밥시킬까염");
      //when


      //then

  }

}