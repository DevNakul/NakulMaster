public class SubmitApproval{
    public SubmitApproval(){
        
    }
    public void submit(){
        Approval.ProcessSubmitRequest req = new Approval.ProcessSubmitRequest();
        req.setComments('Submitted for approval. Please approve.');
        Id objId = ApexPages.currentPage().getParameters().get('id');
        req.setObjectId(objId );
        // submit the approval request for processing
        Approval.ProcessResult result = Approval.process(req);
        // display if the reqeust was successful
        System.debug('Submitted for approval successfully: '+result.isSuccess());
    }
}