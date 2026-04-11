import 'package:universal_feed/universal_feed.dart';

import 'inspector.dart';

/// Formats feed inspection results for console output
class ReportFormatter {
  ReportFormatter({
    this.maxLineLength = 100,
    this.maxContentPreview = 200,
  });

  final int maxLineLength;
  final int maxContentPreview;

  /// Format an inspection result for display
  String format(InspectionResult result) {
    final buffer = StringBuffer();
    final feed = result.feed;

    buffer
      ..writeln('═' * maxLineLength)
      ..writeln('FEED: ${feed.title ?? "(untitled)"}')
      ..writeln('═' * maxLineLength)
      ..writeln()
      ..writeln('Format: ${feed.meta.kind.name} ${feed.meta.version}');

    if (!feed.meta.extensions.extensionsIsEmpty) {
      buffer.writeln('Extensions: ${feed.meta.extensions}');
    }
    buffer.writeln();

    _writeSection(buffer, 'FEED METADATA');
    _writeField(buffer, 'GUID', feed.guid);
    _writeField(buffer, 'Title', feed.title);
    _writeField(buffer, 'Description', feed.description);
    _writeField(buffer, 'HTML Link', feed.htmlLink?.href);
    _writeField(buffer, 'XML Link', feed.xmlLink?.href);
    _writeField(buffer, 'Language', feed.language);
    _writeField(buffer, 'Copyright', feed.copyright);
    _writeField(buffer, 'Docs', feed.docs);
    _writeTimestamp(buffer, 'Published', feed.published);
    _writeTimestamp(buffer, 'Updated', feed.updated);

    // Generator
    if (feed.generator != null) {
      final gen = feed.generator!;
      final version = gen.version.isEmpty ? '' : ' v${gen.version}';
      final url = gen.url.isEmpty ? '' : ' (${gen.url})';
      _writeField(buffer, 'Generator', '${gen.name}$version$url');
    }

    // All links
    if (feed.links.isNotEmpty) {
      for (final link in feed.links) {
        final rel = ' [${link.rel}]';
        final type = link.type.isEmpty ? '' : ' (${link.type})';
        _writeField(buffer, 'Link$rel', link.href + type);
      }
    }

    // Authors
    if (feed.authors.isNotEmpty) {
      for (final author in feed.authors) {
        final email = author.email.isNotEmpty ? ' <${author.email}>' : '';
        final url = author.url != null ? ' [${author.url}]' : '';
        _writeField(buffer, 'Author', author.name + email + url);
      }
    }

    // Categories
    if (feed.categories.isNotEmpty) {
      for (final cat in feed.categories) {
        final scheme = cat.scheme != null ? ' [${cat.scheme}]' : '';
        final term = cat.term != null && cat.label != cat.term ? ' (${cat.term})' : '';
        _writeField(buffer, 'Category', '${cat.label}$term$scheme');
      }
    }

    // Images
    if (feed.image != null) {
      _writeField(buffer, 'Image URL', feed.image!.url);
      _writeField(buffer, 'Image Title', feed.image!.title);
      _writeField(buffer, 'Image Link', feed.image!.link);
      if (feed.image!.width != null) _writeField(buffer, 'Image Width', feed.image!.width.toString());
      if (feed.image!.height != null) _writeField(buffer, 'Image Height', feed.image!.height.toString());
      _writeField(buffer, 'Image Description', feed.image!.description);
    }

    if (feed.icon != null) {
      _writeField(buffer, 'Icon URL', feed.icon!.url);
      _writeField(buffer, 'Icon Title', feed.icon!.title);
    }

    // Extension data
    if (feed.syndication != null) {
      buffer.writeln();
      _writeSection(buffer, 'SYNDICATION EXTENSION');
      _writeField(buffer, 'Update Period', feed.syndication!.updatePeriod);
      _writeField(buffer, 'Update Frequency', feed.syndication!.updateFrequency?.toString());
      _writeField(buffer, 'Update Base', feed.syndication!.updateBase);
    }

    if (feed.podcast != null) {
      buffer.writeln();
      _writeSection(buffer, 'PODCAST/ITUNES EXTENSION');
      final pod = feed.podcast!;
      _writeField(buffer, 'Author', pod.author);
      _writeField(buffer, 'Owner', pod.owner != null ? '${pod.owner!.name} <${pod.owner!.email}>' : null);
      _writeField(buffer, 'Summary', pod.summary);
      _writeField(buffer, 'Explicit', pod.explicit?.toString());
      _writeField(buffer, 'Type', pod.type);
      _writeField(buffer, 'Complete', pod.complete?.toString());
      _writeField(buffer, 'New Feed URL', pod.newFeedUrl);
      if (pod.categories.isNotEmpty) {
        for (final cat in pod.categories) {
          final scheme = cat.scheme != null ? ' [${cat.scheme}]' : '';
          _writeField(buffer, 'Category', '${cat.label}$scheme');
          for (final child in cat.children) {
            final childScheme = child.scheme != null ? ' [${child.scheme}]' : '';
            _writeField(buffer, '  └─ Subcategory', '${child.label}$childScheme');
          }
        }
      }
      if (pod.image != null) {
        _writeField(buffer, 'Podcast Image', pod.image!.url);
      }
    }

    // Items
    buffer.writeln();
    _writeSection(buffer, 'ITEMS (${feed.items.length})');
    for (var i = 0; i < feed.items.length; i++) {
      buffer.writeln();
      _writeItem(buffer, feed.items[i], i);
    }

    // Issues
    if (result.issues.isNotEmpty) {
      buffer.writeln();
      _writeSection(buffer, 'ISSUES (${result.issues.length})');
      for (final issue in result.issues) {
        buffer.writeln(issue.toString());
      }
    }

    buffer
      ..writeln()
      ..writeln('═' * maxLineLength);

    return buffer.toString();
  }

  void _writeItem(StringBuffer buffer, Item item, int index) {
    buffer
      ..writeln('[$index] ${_truncate(item.title ?? "(untitled)", 80)}')
      ..writeln('  │');

    // Basic fields
    // Check if GUID is a permalink (isPermaLink=true, used as link)
    // When isPermaLink="true" in RSS, the guid value becomes item.link with rel=alternate
    final isPermalink =
        item.guid != null &&
        item.link != null &&
        item.link!.href == item.guid &&
        item.link!.rel == LinkRelationType.alternate;
    final permalinkTag = isPermalink ? ' [permalink]' : '';
    _writeField(buffer, 'GUID', item.guid != null ? '${item.guid}$permalinkTag' : null, indent: '  ├─ ');
    _writeField(buffer, 'Title', item.title, indent: '  ├─ ');
    _writeField(buffer, 'Copyright', item.copyright, indent: '  ├─ ');

    // Links
    _writeField(buffer, 'Link', item.link?.href, indent: '  ├─ ');
    if (item.links.isNotEmpty) {
      for (final link in item.links) {
        final rel = ' [${link.rel}]';
        final type = link.type.isEmpty ? '' : ' (${link.type})';
        _writeField(buffer, 'Link$rel', link.href + type, indent: '  ├─ ');
      }
    }

    // Timestamps
    _writeTimestamp(buffer, 'Published', item.published, indent: '  ├─ ');
    _writeTimestamp(buffer, 'Updated', item.updated, indent: '  ├─ ');

    // Authors
    if (item.authors.isNotEmpty) {
      for (final author in item.authors) {
        final email = author.email.isNotEmpty ? ' <${author.email}>' : '';
        final url = author.url != null ? ' [${author.url}]' : '';
        _writeField(buffer, 'Author', author.name + email + url, indent: '  ├─ ');
      }
    }

    // Categories
    if (item.categories.isNotEmpty) {
      for (final cat in item.categories) {
        final scheme = cat.scheme != null ? ' [${cat.scheme}]' : '';
        final term = cat.term != null && cat.label != cat.term ? ' (${cat.term})' : '';
        _writeField(buffer, 'Category', '${cat.label}$term$scheme', indent: '  ├─ ');
      }
    }

    // Image
    if (item.image != null) {
      _writeField(buffer, 'Image', item.image!.url, indent: '  ├─ ');
    }

    // Source
    if (item.source != null) {
      _writeField(buffer, 'Source', '${item.source!.href} [${item.source!.rel}]', indent: '  ├─ ');
    }

    // Source Entry (Atom)
    if (item.sourceEntry != null) {
      final src = item.sourceEntry!;
      _writeField(buffer, 'Source Entry', src.title, indent: '  ├─ ');
      if (src.guid != null) _writeField(buffer, 'Source GUID', src.guid, indent: '  │  ├─ ');
      if (src.updated != null) _writeTimestamp(buffer, 'Source Updated', src.updated, indent: '  │  └─ ');
    }

    // Comments
    if (item.comments != null) {
      _writeField(buffer, 'Comments', item.comments!.href, indent: '  ├─ ');
    }

    // Description (collapsed)
    if (item.description != null && item.description!.isNotEmpty) {
      final preview = _truncate(item.description!, maxContentPreview);
      _writeField(buffer, 'Description', preview, indent: '  ├─ ', collapsed: true);
    }

    // Content (collapsed)
    if (item.content.isNotEmpty) {
      for (final content in item.content) {
        final preview = _truncate(content.value, maxContentPreview);
        _writeField(
          buffer,
          'Content [${content.type}]',
          preview,
          indent: '  ├─ ',
          collapsed: true,
        );
      }
    }

    // Enclosures
    if (item.enclosures.isNotEmpty) {
      for (final enc in item.enclosures) {
        final size = enc.length.isNotEmpty ? ' (${enc.length} bytes)' : '';
        _writeField(buffer, 'Enclosure', '${enc.url} [${enc.type}]$size', indent: '  ├─ ');
      }
    }

    // Media RSS - show all details (only if has actual content)
    if (item.media != null) {
      final media = item.media!;
      final hasContent =
          media.title != null ||
          media.description != null ||
          media.content.isNotEmpty ||
          media.thumbnails.isNotEmpty ||
          media.credits.isNotEmpty ||
          media.rating.isNotEmpty ||
          media.categories.isNotEmpty ||
          media.group.isNotEmpty;

      if (hasContent) {
        buffer.writeln('  ├─ Media RSS:');
        _writeField(buffer, 'Title', media.title, indent: '  │  ├─ ');
        _writeField(buffer, 'Description', media.description, indent: '  │  ├─ ');
      }

      if (hasContent && media.content.isNotEmpty) {
        buffer.writeln('  │  ├─ Content (${media.content.length}):');
        for (var i = 0; i < media.content.length; i++) {
          final mc = media.content[i];
          final size = mc.fileSize != null ? ' (${mc.fileSize} bytes)' : '';
          final duration = mc.duration != null ? ' ${mc.duration}s' : '';
          _writeField(buffer, '[$i]', '${mc.url} [${mc.medium ?? mc.type}]$size$duration', indent: '  │  │  ├─ ');
          if (mc.width != null || mc.height != null) {
            _writeField(buffer, 'Size', '${mc.width}x${mc.height}', indent: '  │  │  │  ├─ ');
          }
        }
      }

      if (media.thumbnails.isNotEmpty) {
        buffer.writeln('  │  ├─ Thumbnails (${media.thumbnails.length}):');
        for (var i = 0; i < media.thumbnails.length; i++) {
          final thumb = media.thumbnails[i];
          final size = thumb.width != null && thumb.height != null ? ' [${thumb.width}x${thumb.height}]' : '';
          _writeField(buffer, '[$i]', '${thumb.url}$size', indent: '  │  │  ├─ ');
        }
      }

      if (hasContent && media.credits.isNotEmpty) {
        _writeField(
          buffer,
          'Credits',
          media.credits.map((c) => '${c.value} (${c.role})').join(', '),
          indent: '  │  ├─ ',
        );
      }

      if (hasContent && media.rating.isNotEmpty) {
        _writeField(
          buffer,
          'Ratings',
          media.rating.map((r) => '${r.scheme}: ${r.value}').join(', '),
          indent: '  │  ├─ ',
        );
      }

      if (hasContent && media.categories.isNotEmpty) {
        _writeField(buffer, 'Categories', media.categories.map((c) => c.term).join(', '), indent: '  │  ├─ ');
      }

      // Display media groups (e.g., YouTube feeds use media:group)
      if (media.group.isNotEmpty) {
        for (var groupIdx = 0; groupIdx < media.group.length; groupIdx++) {
          final group = media.group[groupIdx];
          buffer.writeln('  │  ├─ Media Group [$groupIdx]:');
          _writeField(buffer, 'Title', group.title, indent: '  │  │  ├─ ');
          _writeField(buffer, 'Description', group.description, indent: '  │  │  ├─ ');

          if (group.content.isNotEmpty) {
            buffer.writeln('  │  │  ├─ Content (${group.content.length}):');
            for (var i = 0; i < group.content.length; i++) {
              final mc = group.content[i];
              final size = mc.fileSize != null ? ' (${mc.fileSize} bytes)' : '';
              final duration = mc.duration != null ? ' ${mc.duration}s' : '';
              _writeField(
                buffer,
                '[$i]',
                '${mc.url} [${mc.medium ?? mc.type}]$size$duration',
                indent: '  │  │  │  ├─ ',
              );
              if (mc.width != null || mc.height != null) {
                _writeField(buffer, 'Size', '${mc.width}x${mc.height}', indent: '  │  │  │  │  ├─ ');
              }
            }
          }

          if (group.thumbnails.isNotEmpty) {
            buffer.writeln('  │  │  ├─ Thumbnails (${group.thumbnails.length}):');
            for (var i = 0; i < group.thumbnails.length; i++) {
              final thumb = group.thumbnails[i];
              final size = thumb.width != null && thumb.height != null ? ' [${thumb.width}x${thumb.height}]' : '';
              _writeField(buffer, '[$i]', '${thumb.url}$size', indent: '  │  │  │  ├─ ');
            }
          }

          if (group.credits.isNotEmpty) {
            _writeField(
              buffer,
              'Credits',
              group.credits.map((c) => '${c.value} (${c.role})').join(', '),
              indent: '  │  │  ├─ ',
            );
          }

          if (group.rating.isNotEmpty) {
            _writeField(
              buffer,
              'Ratings',
              group.rating.map((r) => '${r.scheme}: ${r.value}').join(', '),
              indent: '  │  │  ├─ ',
            );
          }

          if (group.categories.isNotEmpty) {
            _writeField(buffer, 'Categories', group.categories.map((c) => c.term).join(', '), indent: '  │  │  └─ ');
          }
        }
      }
    }

    // Podcast extension - show all details
    if (item.podcast != null) {
      final pod = item.podcast!;
      buffer.writeln('  ├─ Podcast:');
      _writeField(buffer, 'Title', pod.title, indent: '  │  ├─ ');
      _writeField(buffer, 'Duration', pod.duration, indent: '  │  ├─ ');
      _writeField(buffer, 'Episode', pod.episode, indent: '  │  ├─ ');
      _writeField(buffer, 'Season', pod.season, indent: '  │  ├─ ');
      _writeField(buffer, 'Episode Type', pod.episodeType, indent: '  │  ├─ ');
      _writeField(buffer, 'Explicit', pod.explicit, indent: '  │  ├─ ');
      _writeField(buffer, 'Block', pod.block, indent: '  │  ├─ ');
      _writeField(buffer, 'Summary', pod.summary, indent: '  │  ├─ ');
      if (pod.image != null) _writeField(buffer, 'Image', pod.image!.url, indent: '  │  └─ ');
    }

    // GeoRSS - show all fields (only if has actual content)
    if (item.geo != null) {
      final geo = item.geo!;
      final hasGeoContent =
          geo.line != null ||
          geo.polygon != null ||
          geo.box != null ||
          geo.featureTypeTag != null ||
          geo.relationshipTag != null ||
          geo.featureName != null ||
          geo.elev != null ||
          geo.floor != null ||
          geo.radius != null;

      if (hasGeoContent) {
        buffer.writeln('  ├─ GeoRSS:');
        _writeField(buffer, 'Line', geo.line, indent: '  │  ├─ ');
        _writeField(buffer, 'Polygon', geo.polygon, indent: '  │  ├─ ');
        _writeField(buffer, 'Box', geo.box, indent: '  │  ├─ ');
        _writeField(buffer, 'Feature Type', geo.featureTypeTag, indent: '  │  ├─ ');
        _writeField(buffer, 'Relationship', geo.relationshipTag, indent: '  │  ├─ ');
        _writeField(buffer, 'Feature Name', geo.featureName, indent: '  │  ├─ ');
        _writeField(buffer, 'Elevation', geo.elev, indent: '  │  ├─ ');
        _writeField(buffer, 'Floor', geo.floor, indent: '  │  ├─ ');
        _writeField(buffer, 'Radius', geo.radius, indent: '  │  └─ ');
      }
    }

    // DC Terms - show all fields (only if has actual content)
    if (item.dcterms != null) {
      final dc = item.dcterms!;
      final hasDcContent =
          dc.created != null || dc.modified != null || dc.issued != null || dc.valid != null || dc.available != null;

      if (hasDcContent) {
        buffer.writeln('  ├─ DC Terms:');
        _writeField(buffer, 'Created', dc.created, indent: '  │  ├─ ');
        _writeField(buffer, 'Modified', dc.modified, indent: '  │  ├─ ');
        _writeField(buffer, 'Issued', dc.issued, indent: '  │  ├─ ');
        if (dc.valid != null) {
          _writeField(buffer, 'Valid', '${dc.valid!.start} to ${dc.valid!.end}', indent: '  │  ├─ ');
        }
        if (dc.available != null) {
          _writeField(buffer, 'Available', '${dc.available!.start} to ${dc.available!.end}', indent: '  │  └─ ');
        }
      }
    }
  }

  void _writeSection(StringBuffer buffer, String title) {
    buffer
      ..writeln('─' * maxLineLength)
      ..writeln(title)
      ..writeln('─' * maxLineLength);
  }

  void _writeField(
    StringBuffer buffer,
    String label,
    String? value, {
    String indent = '',
    bool collapsed = false,
  }) {
    if (value == null || value.isEmpty) return;

    final marker = collapsed ? '▸' : ' ';
    final chars = value.length > maxContentPreview ? ' [${value.length} chars]' : '';
    buffer.writeln('$indent$marker $label: $value$chars');
  }

  void _writeTimestamp(
    StringBuffer buffer,
    String label,
    Timestamp? timestamp, {
    String indent = '',
  }) {
    if (timestamp == null) return;

    final parsed = timestamp.parseValue();
    if (parsed != null) {
      buffer.writeln('$indent  $label: ${parsed.toIso8601String()} ← "${timestamp.value}"');
    } else {
      buffer.writeln('$indent  $label: [PARSE FAILED] "${timestamp.value}"');
    }
  }

  // Simple HTML stripping - remove tags and decode common entities
  String _truncate(String text, int maxLength, {bool stripHtml = false}) {
    var result = text.trim();

    if (stripHtml) {
      result = result
          .replaceAll(RegExp('<[^>]*>'), '')
          .replaceAll('&nbsp;', ' ')
          .replaceAll('&lt;', '<')
          .replaceAll('&gt;', '>')
          .replaceAll('&amp;', '&')
          .replaceAll('&quot;', '"')
          .replaceAll(RegExp(r'\s+'), ' ')
          .trim();
    }

    if (result.length <= maxLength) return result;

    return '${result.substring(0, maxLength)}... (+${result.length - maxLength} more)';
  }
}
