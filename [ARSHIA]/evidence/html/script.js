// UPDATE V3 — full visual rewrite: styled "case file" layout (icons per evidence
// type, real case number / analyzing officer / timestamp from the server), a
// clickable close button wired back to the client via a NUI callback, and the same
// generic field renderer as before (still just reflects whatever columns
// Config.EvidenceReportInformation* pulls from `users`, nothing hardcoded).
// UPDATE V8 — DOJ integration: shows the linked esx_uniquejobs case number in the
// header when present, and hides the internal `identifier` field (added server-side
// purely to link suspects into that case) from the visible evidence cards.

function GetParentResourceName() {
    return window.location.hostname || 'evidence';
}

const EVIDENCE_ICON = {
    blood: '🩸',
    bullet: '🔫',
    fingerprint: '🖐️'
};

// Fields pulled from `users` purely for internal linking (DOJ suspects), never meant
// to be displayed on the printed report.
const HIDDEN_FIELDS = ['identifier'];

function fieldLabel(key) {
    return key.replace(/_/g, ' ').replace(/\b\w/g, c => c.toUpperCase());
}

function GenerateReport(payload) {
    const evidence = payload.evidence;
    const caseNumber = payload.caseNumber || '—';
    const analyzedBy = payload.analyzedBy || '—';
    const createdAt = payload.createdAt || 'Just now';
    const dojCaseId = payload.dojCaseId;

    $('#main_container').css({display: 'block', bottom: '-80%'}).animate({bottom: '9%'}, 450, 'swing');

    let html = '';

    html += '<div id="section_header">';
    html += '  <div id="close_button" onclick="CloseReport()">&times;</div>';
    html += '  <div id="header_seal"></div>';
    html += '  <div id="header_details">';
    html += '    <div id="header_title">CASE FILE #' + caseNumber + '</div>';
    html += '    <div id="header_subtitle">Forensics Division — Evidence Report' + (dojCaseId ? ' · Linked to DOJ Case #' + dojCaseId : '') + '</div>';
    html += '    <div id="header_meta">';
    html += '      <div><span class="meta_label">Analyzed By</span><span class="meta_value">' + analyzedBy + '</span></div>';
    html += '      <div><span class="meta_label">Date</span><span class="meta_value">' + createdAt + '</span></div>';
    html += '      <div><span class="meta_label">Items</span><span class="meta_value">' + Object.keys(evidence).length + '</span></div>';
    html += '    </div>';
    html += '  </div>';
    html += '</div>';

    html += '<div id="section_input">';

    const keys = Object.keys(evidence);
    if (keys.length === 0) {
        html += '<div id="empty_state">No evidence attached to this case.</div>';
    } else {
        for (let i = 0; i < keys.length; i++) {
            const item = evidence[keys[i]];
            const icon = EVIDENCE_ICON[item['type']] || '📄';

            html += '<div class="evidence_card ' + (item['type'] || '') + '">';
            html += '  <div class="evidence_card_title"><span class="evidence_icon">' + icon + '</span>EVIDENCE #' + (i + 1) + ' — ' + (item['type'] || 'unknown').toUpperCase() + '</div>';
            html += '  <div class="evidence_fields">';

            for (const [key, value] of Object.entries(item['evidence'] || {})) {
                if (HIDDEN_FIELDS.includes(key)) {
                    continue;
                }

                html += '<div class="header_information_subblock">';
                html += '  <h3>' + fieldLabel(key) + '</h3>';
                html += '  <h4>' + (value === null || value === '' ? '—' : value) + '</h4>';
                html += '</div>';
            }

            html += '  </div>';
            html += '</div>';
        }
    }

    html += '</div>';

    html += '<div id="section_footer"><div id="section_footer_block">Press BACKSPACE or ESC to close</div></div>';

    $('#main_container').html(html);
}

function CloseReport() {
    $('#main_container').html('');
    $('#main_container').css({display: 'none'});

    fetch(`https://${GetParentResourceName()}/closeReport`, {
        method: 'POST',
        headers: {'Content-Type': 'application/json; charset=UTF-8'},
        body: JSON.stringify({})
    }).catch(() => {});
}

window.addEventListener('message', function (event) {
    const edata = event.data;

    if (edata.type === 'showReport') {
        GenerateReport({
            evidence: JSON.parse(edata.evidence),
            caseNumber: edata.caseNumber,
            analyzedBy: edata.analyzedBy,
            createdAt: edata.createdAt,
            dojCaseId: edata.dojCaseId
        });
    } else if (edata.type === 'close') {
        $('#main_container').html('');
        $('#main_container').css({display: 'none'});
    }
});
