module FaveSnopsHelper

  def get_decayed_popularity(snop)
    return snop.popularity * Math.exp(-(Time.now - snop.updated_at)/(Time.now - 7.days.ago))
  end

  # Takes a delta to add after decaying the popularity
  # Updates the snop accordingly
  def recalc_popularity(snop, delta)
    Snop.update(snop, :popularity => get_decayed_popularity(snop) + delta)
  end

end
