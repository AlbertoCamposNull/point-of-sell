@isTest private class ScheduledContactDeleteTest{
    public static testmethod void executeTest(){
        Test.startTest();
            
            String CRON_EXP = '0 0 0 * * ?';
            String jobId = System.schedule('ScheduledContactDeleteTest', CRON_EXP, new ScheduledContactDelete());
            CronTrigger ct = [SELECT Id, CronExpression, TimesTriggered, NextFireTime FROM CronTrigger WHERE id = :jobId]; 
            System.assertEquals(0, ct.TimesTriggered); 
            System.assertEquals('2022-05-11 00:00:00', String.valueOf(ct.NextFireTime));   

        
        Test.stopTest();        
    }
}
