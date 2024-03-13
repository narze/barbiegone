<script lang="ts">
  import card from "../../scraper/card.png"
  import data from "../../scraper/data.json"
  import { onMount } from "svelte"
  import QRCode from "qrcode"

  const {
    point, // 231
    cardType, // "Friend"
    cardId, // "xxxxxxxxxxx"
    level, // "GON GANG FRIEND"
    spending, // 386
    expireDate, // "2025-12-31
    updated_at, // "2024-03-13T22:50:53+07:0
  } = data[data.length - 1]

  // const expire_date_display = format(new Date(expire_date), "dd/MM/yyyy")
  // const progress = Math.min(Math.round((acc_points / 1200) * 100), 100)
  let show = false

  // function showData() {
  //   alert(JSON.stringify(data, null, 2))
  // }

  function qrcode(node, options) {
    const { value, size } = options
    QRCode.toCanvas(node, value, {
      margin: 0,
      width: size,
    })
  }

  onMount(() => {
    const local = window.location.href.includes("localhost")

    const urlParams = new URLSearchParams(window.location.search)
    const debug = urlParams.has("debug")

    if (navigator.userAgent.includes("Line/") || debug || local) {
      show = true
      motd()
    } else {
      alert("เปิดในแอป LINE เดี๋ยวไม่เนียน")
      window.location.href = "https://line.me/R/nv/chat"
    }
  })

  function motd() {
    const key = "barbiegone-motd"

    let currentDate = new Date().toDateString()

    let lastAlertDate = localStorage.getItem(key)

    if (lastAlertDate !== currentDate) {
      const message = [
        "วิธีใช้งาน",
        "1. โชว์ QR Code ให้พนักงานสแกน",
        "2. รับส่วนลด",
      ].join("\n")

      localStorage.setItem(key, currentDate)

      setTimeout(() => {
        alert(message)
      }, 1000)
    }
  }
</script>

{#if show}
  <main class="container kanit-light mx-auto py-4 max-w-xl">
    <div class="p-4">
      <img src={card} alt="card" class="max-w-full h-auto" />
    </div>

    <div class="grid grid-cols-2 gap-4 w-full p-8">
      <div>
        <div class="text-sm">ชื่อสมาชิก</div>
        <div class="text-lg kanit-regular">ริก แอสลี่ย์</div>
      </div>

      <div>
        <div class="text-sm">เลขสมาชิก</div>
        <div class="text-lg kanit-regular">{cardId}</div>
      </div>

      <div>
        <div class="text-sm">ประเภทบัตร</div>
        <div class="text-lg kanit-regular">{cardType}</div>
      </div>

      <div>
        <div class="text-sm">ยอดใช้จ่ายสะสม</div>
        <div class="text-lg kanit-regular">{spending}</div>
      </div>

      <div>
        <div class="text-sm">คะแนนสะสมทั้งหมด</div>
        <div class="text-3xl kanit-medium">{point}</div>
      </div>

      <div>
        <div class="text-sm">คะแนนสะสมจะหมดอายุ</div>
        <div class="text-sm">
          {point} คะแนน : {new Date(expireDate).toLocaleDateString("en-GB")}
        </div>
      </div>
    </div>

    <div class="flex items-center flex-col gap-6">
      <canvas use:qrcode={{ value: cardId, size: 80 }} />

      <div class="flex items-center flex-col text-base">
        <div>สแกนเพื่อสะสมแต้มได้ที่นี่</div>
        <div>
          {new Date().toLocaleDateString("en-GB")}
          {new Date().toLocaleTimeString("en-GB", {
            hour: "2-digit",
            minute: "2-digit",
          })}
        </div>
      </div>

      <a
        href="https://www.youtube.com/watch?v=dQw4w9WgXcQ"
        class="text-sm underline text-[#007bff]">เช็คสิทธิประโยชน์สมาชิก</a
      >
    </div>

    <!-- <pre>{JSON.stringify(data, null, 2)}</pre> -->
    <div class="pt-[100%]">
      <div class="text-xs text-center text-gray-300">
        Last updated: {updated_at}
      </div>
    </div>
  </main>
{/if}

<style lang="postcss">
  @import url("https://fonts.googleapis.com/css2?family=Kanit:ital,wght@0,200;0,300;0,400;0,500;0,700;1,200;1,300;1,400;1,500;1,700&display=swap");

  .kanit-extralight {
    font-family: "Kanit", sans-serif;
    font-weight: 200;
    font-style: normal;
  }

  .kanit-light {
    font-family: "Kanit", sans-serif;
    font-weight: 300;
    font-style: normal;
  }

  .kanit-regular {
    font-family: "Kanit", sans-serif;
    font-weight: 400;
    font-style: normal;
  }

  .kanit-medium {
    font-family: "Kanit", sans-serif;
    font-weight: 500;
    font-style: normal;
  }

  .kanit-bold {
    font-family: "Kanit", sans-serif;
    font-weight: 700;
    font-style: normal;
  }

  .kanit-extralight-italic {
    font-family: "Kanit", sans-serif;
    font-weight: 200;
    font-style: italic;
  }

  .kanit-light-italic {
    font-family: "Kanit", sans-serif;
    font-weight: 300;
    font-style: italic;
  }

  .kanit-regular-italic {
    font-family: "Kanit", sans-serif;
    font-weight: 400;
    font-style: italic;
  }

  .kanit-medium-italic {
    font-family: "Kanit", sans-serif;
    font-weight: 500;
    font-style: italic;
  }

  .kanit-bold-italic {
    font-family: "Kanit", sans-serif;
    font-weight: 700;
    font-style: italic;
  }
</style>
