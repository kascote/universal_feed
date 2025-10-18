import './dcperiod.dart';

/// DcTerms is an extension to Dublin core
///
/// https://web.resource.org/rss/1.0/modules/dcterms/
class DcTerms {
  /// Date of creation of the resource.
  String? created;

  /// Date of formal issuance (e.g., publication) of the resource.
  String? issued;

  /// Date on which the resource was changed.
  String? modified;

  /// Date (often a range) of validity of a resource.
  DcPeriod? valid;

  /// Date (often a range) that the resource will become or did become available.
  DcPeriod? available;

  /// Creates a new empty [DcTerms]
  DcTerms();
}
