@isTest
private class NextDueTaskTriggerTest {

static testMethod void insertATask() {
Project__c priggityproject = new Project__c();

insert priggityproject;

Task tiggitytask = new Task();

tiggitytask.WhatId = priggityproject.Id;
tiggitytask.Subject = 'Reassign Record Types';
tiggitytask.ActivityDate = system.today();
tiggitytask.Status = 'Open';

insert tiggitytask;

}
}