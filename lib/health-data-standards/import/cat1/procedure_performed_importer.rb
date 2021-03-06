module HealthDataStandards
  module Import
    module Cat1
      class ProcedurePerformedImporter < CDA::SectionImporter
        def initialize(entry_finder=CDA::EntryFinder.new("./cda:entry/cda:procedure[cda:templateId/@root = '2.16.840.1.113883.10.20.24.3.64']"))
          super(entry_finder)
          @entry_class = Procedure
          @ordinality_xpath = "./cda:priorityCode"
          @incision_xpath ="./cda:entryRelationship/cda:procedure[./cda:templateId[@root='2.16.840.1.113883.10.20.24.3.89']]/cda:effectiveTime"
        end
        
        def create_entry(entry_element, nrh = CDA::NarrativeReferenceHandler.new)
          procedure = super
          extract_ordinality(entry_element, procedure)
          extract_incision_date_time(entry_element,procedure)
          extract_negation(entry_element, procedure)
          procedure
        end

        private

        def extract_ordinality(parent_element, procedure)
          ordinality_element = parent_element.at_xpath(@ordinality_xpath)
          if ordinality_element
            procedure.ordinality = {CodeSystemHelper.code_system_for(ordinality_element['codeSystem']) => [ordinality_element['code']]}
          end
        end

        def extract_incision_date_time(parent_element, procedure)
          incision_time = parent_element.at_xpath(@incision_xpath)
          if incision_time
            procedure.incision_time = HL7Helper.timestamp_to_integer(incision_time['value'])
          end
        end
      end
    end
  end
end