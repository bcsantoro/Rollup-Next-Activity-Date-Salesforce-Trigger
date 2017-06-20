trigger NextDueTaskTrigger on Task (after insert, after update) {
Project__c[] projList = new Project__c[]{}; // Replace Project__c with object you're dealing with
Id[] taskIdList = new Id[]{};

for(Task tk : Trigger.new){
String str = tk.whatid;
if(str != null && str.substring(0,3)== 'a00'){ // ensure to replace with substring for object you're dealing with
taskIdList.add(tk.whatid);
}
}

Map<ID, Project__c> projects = new Map<ID, Project__c>([select OwnerId,Next_Activity_Date__c,Next_Activity_Subject__c,Next_Activity_Subject_Id__c from Project__c where Id in : taskIdList ]);
// creates a list and queries for the appropriate Task records ordered by ActivityDate
List<Task> tskAll = [Select Id,ActivityDate,Status,Subject,WhatId From Task where WhatId in :taskIdList and Status = 'Open' and ActivityDate != null and isClosed = false order By ActivityDate ];
Map<Id, Task> projectTaskMap = new Map<Id, Task>();
for(Task tskMin : tskAll){
if(projectTaskMap.containsKey(tskMin.whatid)){
if(tskMin.ActivityDate < projectTaskMap.get(tskMin.whatid).ActivityDate){
projectTaskMap.put(tskMin.whatid,tskMin);

}

}else {
projectTaskMap.put(tskMin.whatid,tskMin);
}
}

for(Task tk : Trigger.new){

String str = tk.whatid;
if(str != null && str.substring(0,3)== 'a00')
{

Project__c proj = projects.get(tk.whatid);
if (projectTaskMap.get(proj.Id) != null) {
proj.Next_Activity_Date__c=projectTaskMap.get(proj.Id).ActivityDate;
proj.Next_Activity_Subject__c=projectTaskMap.get(proj.Id).Subject;
proj.Next_Activity_Subject_Id__c=projectTaskMap.get(proj.Id).Id;
}
else {
proj.Next_Activity_Date__c=null;
proj.Next_Activity_Subject__c='';
proj.Next_Activity_Subject_Id__c=null;
}
projList.add(proj);
}

}
update projList;
}