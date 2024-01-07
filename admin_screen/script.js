
let adminId = 1
let spotsList = [];
let stamprallyList = [];
let spotFileReader = new FileReader();

$('#spots_list').empty();
$('#stamprallies_list').empty();
$('.stamprally_info').css('display', 'none');
$('.spot_info').css('display', 'none');


(async () => {
  $('#spots_list').empty();
  $('#included_spots_list').empty();
  spotsList = await getData(
    '/get/admin/spots',
    { id: adminId }
  )


  for (let i = 0; i < spotsList.length; i++) {
    const element = spotsList[i];
    spotsOptionTag = $('<option>', {id: 'spots', value: element['id'], text: element['title']});
    $('#spots_list').append(spotsOptionTag);
    spotsOptionTag = $('<option>', {id: 'included_spots', value: element['id'], text: element['title']});
    $('#included_spots_list').append(spotsOptionTag);
  }
})();
(async () => {
  $('#stamprallies_list').empty();
  spotsList = await getData(
    '/get/admin/stamprallies',
    { id: adminId }
  )

  for (let i = 0; i < spotsList.length; i++) {
    const element = spotsList[i];
    spotsOptionTag = $('<option>', {id: 'spots', value: element['id'], text: element['title']});
    $('#stamprallies_list').append(spotsOptionTag);
  }
})();



$('#add_spot').click(() => {
  console.log('aa');
  $('.stamprally_info').css('display', 'none');
  $('.spot_info').find('input').val('');
  $('#spot_img_preview').removeAttr('src')
  $('#save_spot_info').css('display', 'none');
  $('#add_spot_info').css('display', 'block');
  $('.spot_info').css('display', 'block');
})
$('#add_stamprally').click(() => {
  console.log('add_stamprally');
  $('.spot_info').css('display', 'none');
  $('.stamprally_info').find('input').val('');
  $('#stamprally_img_preview').removeAttr('src')
  $('#save_stamprally_info').css('display', 'none');
  $('#add_stamprally_info').css('display', 'block');
  $('.stamprally_info').css('display', 'block');
})


$(document).on("change","#spot_img",function(){
  console.log('spot_img');
  let elem = this                                             //操作された要素を取得
  spotFileReader = new FileReader();                          //ファイルを読み取るオブジェクトを生成
  spotFileReader.readAsDataURL(elem.files[0]);                    //ファイルを読み取る
  spotFileReader.onload = (function () {
      $('#spot_img_preview').attr('src',spotFileReader.result)
  });
})

$(document).on("change","#stamprally_img",function(){
  console.log('stamprally_img');
  let elem = this                                             //操作された要素を取得
  spotFileReader = new FileReader();                          //ファイルを読み取るオブジェクトを生成
  spotFileReader.readAsDataURL(elem.files[0]);                    //ファイルを読み取る
  spotFileReader.onload = (function () {
      $('#stamprally_img_preview').attr('src',spotFileReader.result)
  });
})

$(document).on("change","#reward_img",function(){
  console.log('reward_img');
  let elem = this                                             //操作された要素を取得
  spotFileReader = new FileReader();                          //ファイルを読み取るオブジェクトを生成
  spotFileReader.readAsDataURL(elem.files[0]);                    //ファイルを読み取る
  spotFileReader.onload = (function () {
      $('#reward_img_preview').attr('src',spotFileReader.result)
  });
})


$("#add_spot_info").click(function () {
  if (
    $('#spot_title').val() &&
    $('#spot_explanation').val() &&
    $('#spot_website').val() &&
    $('#spot_openHours').val() &&
    $('#spot_admissionFee').val() &&
    $('#spot_address').val() &&
    $('#spot_location_lat').val() &&
    $('#spot_location_lon').val() &&
    $('#spot_img').val() &&
    $('#spot_tags').val()
  ) {
    var formData = new FormData();
    var fileField = document.querySelector('#spot_img');
    console.log(fileField.files[0])
    formData.append('image', fileField.files[0]);

    const tags = ($('#spot_tags').val()).split(',')
    formData.append(
      'info',
      JSON.stringify({
        'title':$('#spot_title').val(),
        'explanation':$('#spot_explanation').val(),
        'website':$('#spot_website').val(),
        'openHours':$('#spot_openHours').val(),
        'admissionFee':$('#spot_admissionFee').val(),
        'address':$('#spot_address').val(),
        'lat':$('#spot_location_lat').val(),
        'lon':$('#spot_location_lon').val(),
        'tags':tags,
        'admin':adminId,
      })
    );

    // Fetch APIを使用してデータをPOST
    fetch('http://localhost:3000/post/admin/spot', {
      method: 'POST',
      body: formData
    })
    .then(response => response.json())
    .then(result => console.log('Success:', result))
    .catch(error => console.error('Error:', error));
  }
})


$("#add_stamprally_info").click(function () {
  if (
    $('#stamprally_title').val() &&
    $('#stamprally_period').val() &&
    $('#stamprally_venue').val() &&
    $('#stamprally_url').val() &&
    $('#stamprally_explanation').val() &&
    $('#stamprally_img').val() &&
    $('#reward_img').val() &&
    $('#reward_title').val() &&
    $('#reward_explanation').val() &&
    $('#reward_conditions').val() &&
    $('#included_spots_list').val()
  ) {
    console.log($('#included_spots_list').val())
    var formData = new FormData();
    const fileFieldSpot = document.querySelector('#spot_img');
    console.log(fileFieldSpot.files[0])
    formData.append('spotImage', fileFieldSpot.files[0]);

    const fileFieldReward = document.querySelector('#reward_img');
    console.log(fileFieldReward.files[0])
    formData.append('rewardImage', fileFieldReward.files[0]);

    formData.append(
      'info',
      JSON.stringify({
        'title':$('#stamprally_title').val(),
        'explanation':$('#stamprally_explanation').val(),
        'website':$('#stamprally_url').val(),
        'period':$('#stamprally_period').val(),
        'venue':$('#stamprally_venue').val(),
        'reward_title':$('#reward_title').val(),
        'reward_explanation':$('#reward_explanation').val(),
        'reward_conditions':$('#reward_conditions').val(),
        'spots': $('#included_spots_list').val(),
        'admin':adminId,
      })
    );

    // Fetch APIを使用してデータをPOST
    fetch('http://localhost:3000/post/admin/stamprally', {
      method: 'POST',
      body: formData
    })
    .then(response => response.json())
    .then(result => console.log('Success:', result))
    .catch(error => console.error('Error:', error));
  }

});

async function getData(path, params) {
  const query_params = new URLSearchParams(params);
  res = await fetch('http://localhost:3000' + path + '?' + query_params)
  const data = await res.json();
  console.log(data);
  return data;
}


// フォームデータを作成


// CREATE TABLE admin_user (
//     id INT  NOT NULL AUTO_INCREMENT,
//     uid  VARCHAR(28) NOT NULL,
//     PRIMARY KEY (id)
// );

// ALTER TABLE admin_user RENAME TO admin_users;


// 1
// ALTER TABLE spots ADD admin int;

// UPDATE stamp_rallies SET admin = 1;

// INSERT INTO admin_users (uid) VALUES ('PIZKJ0rPYffI7H7f5WX7gs2RWjE3');