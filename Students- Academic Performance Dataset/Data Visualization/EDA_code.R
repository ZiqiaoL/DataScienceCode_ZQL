
library(dplyr)
library(ggplot2)
ADP <- read.csv("~/Downloads/xAPI-Edu-Data.csv", header=T,stringsAsFactors = F)
head(ADP)
summary(ADP)
sum(is.na(ADP))
ADP$Class <- factor(ADP$Class, levels = c("L", "M","H"))

## plot1 : demographical features of students
##students' nationality, total number, gender portion
diff_gender = ADP %>% select(., NationalITy, gender) %>%
  group_by(.,NationalITy, gender ) %>% 
  summarise(., total = n())

p1 <-ggplot(diff_gender, aes(x = reorder(NationalITy, total), y = total, fill = gender)) + 
  geom_bar(stat = "identity")+ 
  geom_text( aes(label = total),size=3,position = position_stack(vjust = 0.5))+
  coord_flip()+
  ylab("Count")+
  xlab("Nationality")+
  ggtitle("Students' Demographical Features")
p1

## plot2 : demographical features of students
##Parent responsible for student and situations of grades
diff_relation = ADP %>% select(., Class, Relation) %>%
  group_by(.,Class,Relation ) %>% 
  summarise(., total = n())

p2 <-ggplot(diff_relation, aes(x=Class,y=total, fill= Relation)) +
    geom_bar(stat = "identity")+ 
    scale_x_discrete(limits=c("L","M","H"))+
    geom_text(aes(label = total),size=3,position = position_stack(vjust = 0.5))+
    ylab("Count")+
    xlab("Total Grade Level (L:[0-69], M:[70-89], H:[90-100])")+
    ggtitle("Parents' responsible VS. Students' performance")
p2

#plot3: plot grade  [1] "G-04" "G-07" "G-08" "G-06" "G-05" "G-09" "G-12" "G-11" "G-10" "G-02"
p3 <- ggplot(ADP, aes(x=GradeID))+ geom_bar(aes(fill=Class))+
      ylab("Count")+
      xlab("Grade Level")
p3

#plot4: SectionID
p4 <- ggplot(ADP, aes(x=SectionID))
p4+geom_bar(aes(fill=Class))

#plot5: Semester
p5 <- ggplot(ADP, aes(x=Semester))
p5+geom_bar(aes(fill=Class))


#plot6: Boys Girls different perference
diff_topic = ADP %>% select(., Topic, gender) %>%
  group_by(.,Topic, gender ) %>% 
  summarise(., total = n())
p6 <-ggplot(diff_topic, aes(x = reorder(Topic, total), y = total, fill = gender)) + 
  geom_bar(stat = "identity", position="dodge")+ 
  geom_text(aes(label = total),size=3)+
  coord_flip()+
  ylab("Count")+
  xlab("Topic")+
  ggtitle("Boys and Girls, different perferences?")
p6

#plot7: Parent response to survey
diff_survey = ADP %>% select(.,ParentAnsweringSurvey, Class) %>%
  group_by(.,ParentAnsweringSurvey, Class) %>% 
  summarise(., total = n())

p7 <- ggplot(diff_survey, aes(x = ParentAnsweringSurvey, y = total, fill = Class)) + 
      geom_bar(stat = "identity")+ 
      geom_text( aes(label = total),size=3, position = position_stack(vjust = 0.5))+
      ylab("Count")+
      xlab("Parents Answered Survey?")
p7

#plot8: Parent School Satisfaction
diff_satisf = ADP %>% select(.,ParentschoolSatisfaction, Class) %>%
  group_by(.,ParentschoolSatisfaction, Class) %>% 
  summarise(., total = n())
p8 <- ggplot(diff_satisf, aes(x = ParentschoolSatisfaction, y = total, fill = Class)) + 
      geom_bar(stat = "identity")+ 
      geom_text( aes(label = total),size=3, position = position_stack(vjust = 0.5))+
      ylab("Count")+
      xlab("Parents Satisfied School?")
p8

##How about high grade students with not satisfied parents 
bad <- ADP%>%filter(ParentschoolSatisfaction=="Bad"&Class=="H")
bad_plot <- ggplot(bad, aes(x = Semester)) + 
             geom_bar(aes(fill=SectionID))+
             xlab("Semester")+
             ylab("Count")
bad_plot


##combine plot7 and plot8
library(gridExtra)
grid.arrange(p7, p8, ncol=2, nrow =1)

######student behavior
## plot9: Times the student visits a course content: 
#could figure out students with high efficiency
p9 <- ggplot(data = ADP, aes(x = VisITedResources))+ 
      geom_histogram(aes(fill=Class),binwidth = 2)+
      ylab("Count")+
      xlab("Times the student visits a course content")
p9

##plot10: students from which country are more active on class
###raise hands by different country

p10 <- ggplot(data = ADP, aes(x = reorder(NationalITy,raisedhands), y =raisedhands))+
      geom_boxplot(aes(fill=Class))+coord_flip()+theme_bw()+
      ylab("How many times the student raises his/her hand on classroom ")+
      xlab("Nationality")
p10

###stident from venzuela
student_venzuela <- ADP%>%filter(.,NationalITy=="venzuela")
student_venzuela
## only 1 Male raisedhands 80 has high grades

##plot11: Discussion related to performance
p11 <- ggplot(data = ADP, aes(x = Discussion))+
       geom_histogram(aes(fill=Class),binwidth = 2)+
       xlab("Times of the student participated on discussion groups" )+
       ylab("Count")
p11

grid.arrange(p9, p11, ncol=1, nrow =2)

##How about those students less active but with high grades?
efficiency_0 <- ADP%>%filter(VisITedResources<=25&Discussion<=25&Class=="H")
efficiency_0 
# 0 student exist under condition --VisITedResources<=25&Discussion<=25&Class=="H"
efficiency_1 <- ADP%>%filter(VisITedResources<=25&Class=="H")
efficiency_1 

efficiency1_plot <- ggplot(efficiency_1, aes(x = Discussion)) + 
  geom_bar(aes(fill=SectionID))
  #xlab("Semester")+
  #ylab("Count")
efficiency1_plot

#6 students exist, they like 
efficiency_2 <- ADP%>%filter(Discussion<=25&Class=="H")
efficiency_2

efficiency2_plot <- ggplot(efficiency_2, aes(x = raisedhands)) + 
                    geom_histogram(aes(fill=Topic), binwidth = 5)
                    #xlab("Semester")+
                    #ylab("Count")
efficiency2_plot

##plot12: how many times the student visits a course content
p12 <- ggplot(data = ADP, aes(x = VisITedResources))+
       geom_histogram(aes(fill=Class),binwidth = 2)+
       xlab("Times of the student visited a course content" )+
       ylab("Count")
p12

##plot13:how many times the student checks the new announcements
p13 <- ggplot(data = ADP, aes(x = AnnouncementsView))+
       geom_histogram(aes(fill=Class),binwidth = 2)

##plot14:Students likely to go to class:the number of absence days for each student 

diff_ab = ADP %>% select(.,StudentAbsenceDays, Class) %>%
  group_by(.,StudentAbsenceDays,Class) %>% 
  summarise(., total = n())
p14 <- ggplot(diff_ab, aes(x = StudentAbsenceDays, y = total, fill = Class)) + 
  geom_bar(stat = "identity")+ 
  geom_text( aes(label = total),size=3, position = position_stack(vjust = 0.5))+
  xlab("Student Absence Days")+
  ylab("Count")
p14

##plot15: Student Absence Days: Students likely to go to class realted to Nationality
diff_ab_c = ADP %>% select(.,StudentAbsenceDays, NationalITy) %>%
  group_by(.,StudentAbsenceDays,NationalITy) %>% 
  summarise(., total = n())
p15 <- ggplot(diff_ab_c, aes(x = reorder(NationalITy,total), y = total, fill = StudentAbsenceDays)) + 
  geom_bar(stat = "identity", position="dodge")+ 
  geom_text(aes(label = total),size=3, hjust=-0.2)+
  coord_flip()+
  xlab("Nationality")+
  ylab("Count")
  
p15






