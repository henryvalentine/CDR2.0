using Newtonsoft.Json;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using System.Xml.Serialization;

namespace CDR.Models
{
    public class NDRExtract
    {
		public class MessageSendingOrganization
		{
			public string FacilityName { get; set; }
			public string FacilityID { get; set; }
			public string FacilityTypeCode { get; set; }
		}

		public class MessageHeader
		{
			public string MessageStatusCode { get; set; }
			public string MessageCreationDateTime { get; set; }
			public string MessageSchemaVersion { get; set; }
			public string MessageUniqueID { get; set; }
			public MessageSendingOrganization MessageSendingOrganization { get; set; }
		}

		public class TreatmentFacility
		{
			public string FacilityName { get; set; }
			public string FacilityID { get; set; }
			public string FacilityTypeCode { get; set; }
		}

		public class Identifier
		{
			public string IDNumber { get; set; }
			public string IDTypeCode { get; set; }
		}

		public class OtherPatientIdentifiers
		{
			public Identifier Identifier { get; set; }
		}

		public class RightHand
		{
			public string RightThumb { get; set; }
			public string RightIndex { get; set; }
			public string RightMiddle { get; set; }
			public string RightWedding { get; set; }
			public string RightSmall { get; set; }
		}

		public class LeftHand
		{
			public string LeftThumb { get; set; }
			public string LeftIndex { get; set; }
			public string LeftMiddle { get; set; }
			public string LeftWedding { get; set; }
			public string LeftSmall { get; set; }
		}

		public class FingerPrints
		{
			public string DateCaptured { get; set; }
			public RightHand RightHand { get; set; }
			public LeftHand LeftHand { get; set; }
			public string Source { get; set; }
			public string Present { get; set; }
		}

		public class PatientDemographics
		{
			public string PatientIdentifier { get; set; }
			public TreatmentFacility TreatmentFacility { get; set; }
			public OtherPatientIdentifiers OtherPatientIdentifiers { get; set; }
			public string PatientDateOfBirth { get; set; }
			public string PatientSexCode { get; set; }
			public FingerPrints FingerPrints { get; set; }
			public string EnrolleeCode { get; set; }
		}

		public class ProgramArea
		{
			public string ProgramAreaCode { get; set; }
		}

		public class PatientAddress
		{
			public string AddressTypeCode { get; set; }
			public string StateCode { get; set; }
			public string CountryCode { get; set; }
		}

		public class CommonQuestions
		{
			public string HospitalNumber { get; set; }
			public string DateOfFirstReport { get; set; }
			public string DateOfLastReport { get; set; }
			public string DiagnosisDate { get; set; }
			public string PatientDieFromThisIllness { get; set; }
			public string PatientAge { get; set; }
		}

		public class HIVQuestions
		{
			public string FirstConfirmedHIVTestDate { get; set; }
			public string ARTStartDate { get; set; }
			public string TransferredOutStatus { get; set; }
			public string EnrolledInHIVCareDate { get; set; }
		}

		public class ConditionSpecificQuestions
		{
			public HIVQuestions HIVQuestions { get; set; }
		}

		public class ARVDrugRegimen
		{
			public string Code { get; set; }
			public string CodeDescTxt { get; set; }
		}

		public class HIVEncounter
		{
			public string VisitID { get; set; }
			public string VisitDate { get; set; }
			public string DurationOnArt { get; set; }
			public string Weight { get; set; }
			public string ChildHeight { get; set; }
			public string BloodPressure { get; set; }
			public string FunctionalStatus { get; set; }
			public string WHOClinicalStage { get; set; }
			public ARVDrugRegimen ARVDrugRegimen { get; set; }
			public string NextAppointmentDate { get; set; }
		}

		public class Encounters
		{
			public List<HIVEncounter> HIVEncounter { get; set; }
		}

		public class LaboratoryResultedTest
		{
			public string Code { get; set; }
			public string CodeDescTxt { get; set; }
		}

		public class AnswerNumeric
		{
			public string Value1 { get; set; }
		}

		public class LaboratoryResult
		{
			public AnswerNumeric AnswerNumeric { get; set; }
		}

		public class LaboratoryOrderAndResult
		{
			public string OrderedTestDate { get; set; }
			public LaboratoryResultedTest LaboratoryResultedTest { get; set; }
			public LaboratoryResult LaboratoryResult { get; set; }
			public string ResultedTestDate { get; set; }
		}

		public class LaboratoryReport
		{
			public string VisitID { get; set; }
			public string VisitDate { get; set; }
			public string CollectionDate { get; set; }
			public string ARTStatusCode { get; set; }
			public LaboratoryOrderAndResult LaboratoryOrderAndResult { get; set; }
		}

		public class PrescribedRegimen
		{
			public string Code { get; set; }
			public string CodeDescTxt { get; set; }
		}

		public class Regimen
		{
			public string VisitID { get; set; }
			public string VisitDate { get; set; }
			public PrescribedRegimen PrescribedRegimen { get; set; }
			public string PrescribedRegimenTypeCode { get; set; }
			public string PrescribedRegimenLineCode { get; set; }
			public string PrescribedRegimenDuration { get; set; }
			public string PrescribedRegimenDispensedDate { get; set; }
			public string DateRegimenStarted { get; set; }
			public string DateRegimenStartedDD { get; set; }
			public string DateRegimenStartedMM { get; set; }
			public string DateRegimenStartedYYYY { get; set; }
			public string DateRegimenEnded { get; set; }
			public string DateRegimenEndedDD { get; set; }
			public string DateRegimenEndedMM { get; set; }
			public string DateRegimenEndedYYYY { get; set; }
			public string PrescribedRegimenInitialIndicator { get; set; }
			public string SubstitutionIndicator { get; set; }
			public string SwitchIndicator { get; set; }
		}

		public class Condition
		{
			public string ConditionCode { get; set; }
			public ProgramArea ProgramArea { get; set; }
			public PatientAddress PatientAddress { get; set; }
			public CommonQuestions CommonQuestions { get; set; }
			public ConditionSpecificQuestions ConditionSpecificQuestions { get; set; }
			public Encounters Encounters { get; set; }
			public List<LaboratoryReport> LaboratoryReport { get; set; }
			public List<Regimen> Regimen { get; set; }
		}

		public class IndividualReport
		{
			public PatientDemographics PatientDemographics { get; set; }
			public Condition Condition { get; set; }
		}

		public class Container
		{
			public MessageHeader MessageHeader { get; set; }
			public IndividualReport IndividualReport { get; set; }
			public string Validation { get; set; }
		}

		public class Extract
		{
			public Container Container { get; set; }
		}
	}
}
