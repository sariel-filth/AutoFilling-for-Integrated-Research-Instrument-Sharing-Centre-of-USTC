require(RSelenium)
require(dplyr)



####################################### Environmental Information Preparation
web_link <- "http://yqzx.ustc.edu.cn/login_cas"
login_name <- "SA16019027"
login_password <- "sariel199524"
interval <- 0.5 # fillment interval
money_bound <- 10000 # 4500 * 7 = 31500




######################################## Prior Information Preparation
equip_list <- c("367","324","323","382","379","327","325","687")

equip_price_list <- c(50, 50, 40, 20, 20, 20, 30, 20)

note_list <-  rbind(
              c("����΢�װ�ʽ��������̽�����⹦�ܻ�����΢��Ļ�ѧ��������",
                "����΢�װ�ʽ��������̽����ͬ��Դ���⹦�ܻ�����΢��֮�仯ѧ�������ܲ���",
                "����΢�װ�ʽ��������̽����ͬ�����ϳɵĹ��ܻ�����΢��֮�仯ѧ�������ܲ���",
                "����΢�װ�ʽ��������̽����ѧ���⹦�ܻ�����΢���ռ����ڻ�ѧ�������ܵ��ȶ���"),
              
              c("���⹦�ܻ����ϵ�ӫ�������о��Լ���������ʶ����о�",
                "ӫ�����ʶԷ��⹦�ܻ����ϵķ������Ӱ���о����Լ�������׵ļ��",
                "ӫ��С�����뷢�⹦�ܻ�������ϵ��ѧ�����໥Ӱ����о�",
                "��ѧ���������ӫ����ӵ���������ת�Ƶ������о�"),
              
              c("��������ֹ��ȼƻ�ȡʯīϩ���ײ��ϵ��������չ���",
                "��������ֹ��ȼ�̽���������ײ��ϵ�������չ���",
                "��������ֹ��ȼƱ�����ѧ���⹦�ܻ�̼���ײ��ϵ��������չ���",
                "��������ֹ��ȼ�̽����ѧ���⹦�ܻ��������ײ��ϵ�������չ���"),
              
              c("˫���ܻ����Ժ�-�ǽ��̼���ϵĵ绯ѧ�����о�",
                "��³��ŵ���������幦�ܻ�������ʯīϩ�绯ѧ�����о�",
                "����³��ŵ���ܻ�̼���ӵ㸴����Ķ�ɫ��λ�ֱ�绯ѧ�����о�",
                "��ѧ�����Լ�/��������˫���ܻ������ײ��ϵĵ绯ѧ�����о�"),
              
              c("̽������ﻯѧ���⶯��ѧ���ߵ������������ѻ�ѧ����",
                "̽������ﻯѧ�����ʱ�����о���ѧ���⶯��ѧ����",
                "ͨ�����Ʊ��������Բ��Ͻ����Ż����õ���ǿ�Ļ�ѧ����",
                "��ѧ���⶯��ѧ���ߵıȽϣ��о��ԱȲ�ͬ�Ļ�ѧ�������ʶԲ��ϵ�Ӱ��"),
              
              c("����̨ʽ�����䶳���Ļ�����������ɹ��ܻ�����ʯīϩ����Һ",
                "����̨ʽ�����䶳���Ļ�����³��ŵ���ܻ�����������Һ",
                "����̨ʽ�����䶳���Ļ�����³��ŵ���ܻ�̼���׹�����Һ", 
                "����̨ʽ�����䶳���Ļ�����ABEI���ܻ�����������Һ"),
              
              c("����̨ʽ���Ļ���̼���׹�����Һ�������ķ���",
                "����̨ʽ���Ļ��Զ�������΢������Һ�������ķ���",
                "����̨ʽ���Ļ��������ײ�������Һ�������ķ���",
                "����̨ʽ���Ļ��Խ����ײ�������Һ�������ķ���"),
              
              c("���ò�����尲�෨�Ժϳ���Ʒ�ĵ绯ѧ���ʽ��з���",
                "�Ժϳ���Ʒ���в���������������������绯ѧ����",
                "ͨ��ѭ��������������õ绯ѧ�����Լ���Ӧԭ��",
                "��������ɨ������������������绯ѧ��Ӧ��ԭ��")
                 )

sample_list <- rbind(
              c("��ѧ����˫���ܻ�����΢��",
                 "��ͬ��Դ��ѧ����˫���ܻ�����΢��",
                 "��ͬ�����ϳɵĹ��ܻ�����΢��",
                 "��ͬ���λ�ѧ���⹦�ܻ�����΢��"),
              c("³��ŵ���⹦�ܻ�����",
                "³��ŵ���ܻ�ʯīϩ����",
                "����������֬ˮ����",
                "���󾫹��ܻ�ʯīϩ"),
              c("ʯīϩ",
                "³��ŵ",
                "̼���׹�",
                "߹���"),
              c("N-��4-����������-N-�һ���³��ŵ",
                "��³��ŵ",
                "³��ŵ",
                "�������"),
              c("��³��ŵ�������Ӻ�ӫ���ˮ����",
                "̼���΢���ڰ��������Ӻ���³��ŵ",
                "ʯīϩ������������³��ŵ",
                "³��ŵ�����󾫡���³��ŵˮ����"),
              c("������ɹ��ܻ�ʯīϩ����Һ",
                "³��ŵ���ܻ�����������Һ",
                "³��ŵ���ܻ�̼���׹�����Һ",
                "ABEI���ܻ�����������Һ"),
              c("̼���׹�",
                "��������΢��",
                "�������Ŵ�",
                "�������Ŵ�"),
              c("��³��ŵ���ܻ����׻�״���׽����",
                "ˮ���Զ�������",
                "����̼���ӵ�",
                "�������ӵ�")
              )

sample_number <- as.character(5: 20)
test_time <- seq(3, 6, 0.5)

user_name <- c("����","������","������","����","�ŵ���","����",
               "������","�߱���", "����ȫ", "������", "����ɯ")

user_id <- c("BA15019002","BA15019001","BA16019013","BA17019002","BA18019002","SA16019027",
             "SA17019031","SA17019011","BA18019003", "SA18019058", "SA18019055")

user_email <- c("leakey@mail.ustc.edu.cn","han303@mail.ustc.edu.cn","ytliu@mail.ustc.edu.cn",
                "yr1992@mail.ustc.edu.cn","dxdu@mail.ustc.edu.cn","sariel@mail.ustc.edu.cn",
                "lvah031@mail.ustc.edu.cn","gaobj@mail.ustc.edu.cn", "gminquan@mail.ustc.edu.cn",
                "wuyuy@mail.ustc.edu.cn", "wys000@mail.ustc.edu.cn")

today_date <- Sys.Date()




####################################### Linkage Establishment 
rD <- rsDriver(check = F)
remDr <- rD[["client"]]
remDr$setImplicitWaitTimeout(milliseconds = 10000)
remDr$navigate(web_link)

remDr$findElement(using = "id", value = "login")$sendKeysToElement(list(login_name))
Sys.sleep(interval)

remDr$findElement(using = "id", value = "password")$sendKeysToElement(list(login_password))
Sys.sleep(interval)

remDr$findElement(using = "id", value = "button")$clickElement()
Sys.sleep(interval)

remDr$findElement(using = "id", value = "my-testing-item")$clickElement()
Sys.sleep(interval)

##################################### Filling Loop Start 

i <- 0

  while(i < 4){
    cur_date <- as.character(today_date - i)
    equip_cost <- rep(0, length(equip_list))
    equip_time <- rep(0, length(equip_list))
    while (sum(equip_cost) < money_bound/4) {
      cat("Day: ", cur_date, "\n")
      cur_instru_id <- sample(1: length(equip_list), 1)
      cur_sample_id <- sample(1: dim(sample_list)[2], 1)
      cur_note_id <- sample(1: dim(note_list)[2], 1)
      cur_duration <- sample(seq(3, 6, 0.5), 1)
      cur_operator_id <- sample(1: length(user_id), 1)
      cur_tester_id <- sample(1: length(user_id), 1)
      
      while((cur_duration + equip_time[cur_instru_id] > 24) & cur_operator_id == cur_tester_id ){
        cur_instru_id <- sample(1: length(equip_list), 1)
        cur_sample_id <- sample(1: dim(note_list)[2], 1)
        cur_duration <- sample(seq(3, 6, 0.5), 1)
        cur_operator_id <- sample(1: length(user_id), 1)
        cur_tester_id <- sample(1: length(user_id), 1)
      }
      
      
      equip_time[cur_instru_id] <- cur_duration + equip_time[cur_instru_id]
      equip_cost[cur_instru_id] <- cur_duration * equip_price_list[cur_instru_id] + 
                                   equip_cost[cur_instru_id]
      
      cat("Equipment_Time:\n", equip_time, "\n")
      cat("Equipment_Cost:\n", equip_cost, "\n")
      
      remDr$findElement(using = "id", value = "toolbar")
      temp$clickElement()
      Sys.sleep(interval)
      
      remDr$findElement(using = "xpath", 
                        value = paste("//select[@name='instrument_id']/option[@value='", 
                                      equip_list[cur_instru_id], "']", sep = ""))$clickElement()
      Sys.sleep(interval)
      
      temp <- remDr$findElement(using = "name", value = "test_date")
      temp$clearElement()
      temp$sendKeysToElement(list(cur_date))
      temp$click()
      Sys.sleep(interval)
      
      temp <- remDr$findElement(using = "name", value = "duration")
      temp$sendKeysToElement(list(as.character(cur_duration)))
      temp$click()
      Sys.sleep(interval)
      
      temp <- remDr$findElement(using = "name", value = "note")
      temp$sendKeysToElement(list(note_list[cur_note_id]))
      temp$click()
      Sys.sleep(interval)
      
      temp <- remDr$findElement(using = "name", value = "sample_name")
      temp$sendKeysToElement(list(sample_list[cur_sample_id]))
      temp$click()
      Sys.sleep(interval)
      
      
      temp <- remDr$findElement(using = "name", value = "sample_count")
      temp$sendKeysToElement(list(as.character(sample(5: 20, 1))))
      temp$click()
      Sys.sleep(interval)
      
      temp <- remDr$findElement(using = "name", value = "tester_number")
      temp$clearElement()
      temp$sendKeysToElement(list(user_id[cur_tester_id]))
      temp$click()
      Sys.sleep(interval)
      
      temp <- remDr$findElement(using = "name", value = "tester_name")
      temp$clearElement()
      temp$sendKeysToElement(list(user_name[cur_tester_id]))
      temp$click()
      Sys.sleep(interval)
      
      temp <- remDr$findElement(using = "name", value = "tester_group")
      temp$clearElement()
      temp$sendKeysToElement(list("��ѧ����Ͽ�ѧѧԺ"))
      temp$click()
      Sys.sleep(interval)
      
      temp <- remDr$findElement(using = "name", value = "tester_email")
      temp$clearElement()
      temp$sendKeysToElement(list(user_email[cur_tester_id]))
      temp$click()
      Sys.sleep(interval)
      
      temp <- remDr$findElement(using = "name", value = "tester_phone")
      temp$clearElement()
      temp$sendKeysToElement(list("055163606857"))
      temp$click()
      Sys.sleep(interval)
      
      temp <- remDr$findElement(using = "name", value = "operator_number")
      temp$clearElement()
      temp$sendKeysToElement(list(user_id[cur_operator_id]))
      temp$click()
      Sys.sleep(interval)
      
      temp <- remDr$findElement(using = "name", value = "operator_name")
      temp$clearElement()
      temp$sendKeysToElement(list(user_name[cur_operator_id]))
      temp$click()
      Sys.sleep(interval)
      
      remDr$findElement(using = "xpath", value = "//form/div[last()]/div/button[@type='submit']")$clickElement()
      Sys.sleep(2)
      }
    i <- i + 1
  }

########################################### Filling End
remDr$close()
rD[["server"]]$stop()
