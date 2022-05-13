%lang starknet

from starkware.cairo.common.cairo_builtins import HashBuiltin

# Stats struct
struct Stats:
    member points: felt
    member assists: felt
    member rebounds: felt
end


# Mapping named "players_storage" that holds the player stats
# using his number as key
@storage_var
func players_storage(number: felt) -> (stats: Stats):
end


@external
func save_player_stats{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr}( player_number: felt, points: felt,  rebounds: felt, assists: felt):
    alloc_locals

    local stats: Stats = Stats(points=points, assists=assists,rebounds=rebounds)
    # adds player to storage var
    players_storage.write(player_number, stats)
    return ()
end

@view
func get_player_stats{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr}(player_number: felt) -> (res: Stats):
    let (res) = players_storage.read(player_number)

    return (res)
end
