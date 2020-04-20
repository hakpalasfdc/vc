global class VSPR19b_schClassRelTypesVisionCare implements Schedulable
{
 global void execute(SchedulableContext sc)
 {
   VSPR19b_RelationshipTypesContactBatch activeNetRelsVC = new VSPR19b_RelationshipTypesContactBatch();
   Database.ExecuteBatch(activeNetRelsVC); 
 }
}