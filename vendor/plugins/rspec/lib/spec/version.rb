module Spec
  module VERSION
    unless defined? MAJOR
      MAJOR  = 1
      MINOR  = 1
      TINY   = 11
      MINESCULE = 7
      

      STRING = [MAJOR, MINOR, TINY, MINESCULE].compact.join('.')

      SUMMARY = "rspec #{STRING}"
    end
  end
end