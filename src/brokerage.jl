abstract type AbstractBrokerage end
get_account(a::AbstractBrokerage, args...; kwargs...) = error("Unimplemented")
get_order(a::AbstractBrokerage, args...; kwargs...) = error("Unimplemented")
get_orders(a::AbstractBrokerage, args...; kwargs...) = error("Unimplemented")
get_positions(a::AbstractBrokerage, args...; kwargs...) = error("Unimplemented")
submit_order(a::AbstractBrokerage, args...; kwargs...) = error("Unimplemented")
cancel_order(a::AbstractBrokerage, args...; kwargs...) = error("Unimplemented")
cancel_orders(a::AbstractBrokerage, args...; kwargs...) = error("Unimplemented")
