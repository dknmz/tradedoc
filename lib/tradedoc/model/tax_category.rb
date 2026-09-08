module Tradedoc
  module Model
    # [BG-30]
    class TaxCategory < Base
      # [BT-118] VAT category code
      # https://unece.org/fileadmin/DAM/trade/untdid/d16b/tred/tred5305.htm
      has :code, Code::TaxCategory

      # [BT-119]
      # Stores as the percentage, not as a fraction of 1. e.g. 4.5% = 4.50
      has :rate_percent, BigDecimal

      # [BT-120]
      has :exemption_reason, String

      # [BT-121]
      # https://docs.peppol.eu/poacc/billing/3.0/codelist/vatex/
      # https://ec.europa.eu/digital-building-blocks/sites/spaces/DIGITAL/pages/467108957/Code+lists
      # Could also be CWA 15577 codes
      has :exemption_reason_code, String

      # https://service.unece.org/trade/untdid/d00a/tred/tred5153.htm
      has :tax_scheme, String
    end
  end
end
