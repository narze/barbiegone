<script lang="ts">
  import logo from "./assets/logo.png"
  import upDiamond from "./assets/up_diamond.png"
  import Card from "./lib/Card.svelte"
  import bg from "./assets/bg.png"
  import card from "../../scraper/card.png"
  import data from "../../scraper/data.json"
  import format from "date-fns/format"
  import formatDistance from "date-fns/formatDistance"
  import { onMount } from "svelte"

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
  let hide = false

  // function showData() {
  //   alert(JSON.stringify(data, null, 2))
  // }

  onMount(() => {
    const local = window.location.href.includes("localhost")

    const urlParams = new URLSearchParams(window.location.search)
    const debug = urlParams.has("debug")

    if (navigator.userAgent.includes("Line/") || debug || local) {
      motd()
    } else {
      hide = true
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

{#if hide}
  <main class="container">
    <img src={card} alt="card" style="max-width: 100%" />

    <pre>{JSON.stringify(data, null, 2)}</pre>
  </main>
{/if}
