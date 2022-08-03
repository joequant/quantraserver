#ifndef QUANTRASERVER_FLOATINGRATEBONDPRICINGREQUEST_H
#define QUANTRASERVER_FLOATINGRATEBONDPRICINGREQUEST_H

#include <map>
#include <string>
#include <vector>

#include <ql/qldefines.hpp>
#include <ql/termstructures/yield/piecewiseyieldcurve.hpp>
#include <ql/termstructures/yieldtermstructure.hpp>
#include <ql/termstructures/yield/ratehelpers.hpp>
#include <ql/termstructures/yield/oisratehelper.hpp>
#include <ql/pricingengines/bond/discountingbondengine.hpp>
#include <ql/cashflows/couponpricer.hpp>
#include <ql/indexes/ibor/eonia.hpp>
#include <ql/indexes/ibor/euribor.hpp>
#include <ql/time/imm.hpp>
#include <ql/time/calendars/target.hpp>
#include <ql/time/daycounters/actual360.hpp>
#include <ql/time/daycounters/thirty360.hpp>
#include <ql/time/daycounters/actualactual.hpp>
#include <ql/math/interpolations/cubicinterpolation.hpp>
#include <ql/math/interpolations/loginterpolation.hpp>

#include "flatbuffers/grpc.h"

#include "quantra_request.h"

#include "price_floating_rate_bond_request_generated.h"
#include "floating_rate_bond_response_generated.h"
#include "common_parser.h"
#include "floating_rate_bond_parser.h"
#include "term_structure_parser.h"
#include "pricer_parser.h"

class FloatingRateBondPricingRequest : QuantraRequest<quantra::PriceFloatingRateBondRequest,
                                                      quantra::PriceFloatingRateBondResponse>
{
public:
    flatbuffers::Offset<quantra::PriceFloatingRateBondResponse> request(std::shared_ptr<flatbuffers::grpc::MessageBuilder> builder, const quantra::PriceFloatingRateBondRequest *request) const;
};

#endif //QUANTRASERVER_FLOATINGRATEBONDPRICINGREQUEST_H