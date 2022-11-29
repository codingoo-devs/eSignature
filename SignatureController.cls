public with sharing class SignatureController {
    @AuraEnabled
    public static void saveSignature(String signElement,Id recId){
        ContentVersion cVersion = new ContentVersion();
        cVersion.ContentLocation = 'S'; //S-Document is in Salesforce.
        cVersion.PathOnClient = 'Signature-'+System.now() +'.png';//File name with extention
        cVersion.Origin = 'H';//C-Content Origin. H-Chatter Origin.
        cVersion.Title = 'Signature-'+recId+'-'+System.now() +'.png';//Name of the file
        cVersion.VersionData = EncodingUtil.base64Decode(signElement);//File content
        Insert cVersion;
        
        //Get the Uploaded doc ContentDocumentId
        Id conDocument = [SELECT ContentDocumentId FROM ContentVersion WHERE Id =:cVersion.Id].ContentDocumentId;
        
        //Insert ContentDocumentLink to share 
        ContentDocumentLink cDocLink = new ContentDocumentLink();
        cDocLink.ContentDocumentId = conDocument;
        cDocLink.LinkedEntityId = recId;
        cDocLink.ShareType = 'I';
        cDocLink.Visibility = 'AllUsers';
        Insert cDocLink;
    }
}