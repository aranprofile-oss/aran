const CORS = {
  "Access-Control-Allow-Origin": "*",
  "Access-Control-Allow-Methods": "GET, OPTIONS",
  "Access-Control-Allow-Headers": "Content-Type"
};

export async function onRequestGet({ request }) {
  const url = new URL(request.url);
  const vodId = url.searchParams.get("vod_id");

  try {
    const apiUrl = `https://vod.sooplive.com/station/aranroh/vod/clip?page=1`;
    const res = await fetch(apiUrl, {
      headers: {
        "User-Agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36",
        "Referer": "https://www.sooplive.com/",
        "Origin": "https://www.sooplive.com"
      }
    });
    const json = await res.json();

    if (vodId) {
      // 특정 VOD ID의 thumb만 반환
      const list = json.data || json.list || json.vods || json.clips || [];
      const found = list.find(v => String(v.titleNo) === String(vodId));
      if (found?.ucc?.thumb) {
        return new Response(JSON.stringify({ thumb: found.ucc.thumb }), {
          headers: { ...CORS, "Content-Type": "application/json" }
        });
      }
      return new Response(JSON.stringify({ thumb: null }), {
        headers: { ...CORS, "Content-Type": "application/json" }
      });
    }

    // 전체 반환 (디버그용)
    return new Response(JSON.stringify(json), {
      headers: { ...CORS, "Content-Type": "application/json" }
    });
  } catch(e) {
    return new Response(JSON.stringify({ error: e.message }), {
      status: 500, headers: { ...CORS, "Content-Type": "application/json" }
    });
  }
}

export async function onRequestOptions() {
  return new Response(null, { headers: CORS });
}
